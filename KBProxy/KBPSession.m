//
//  KBPSession.m
//  KBProxyTest
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "KBPSession.h"

@interface KBPSession (Private)

- (BOOL)openSocket;

- (void)handlePacket:(NSObject *)packet;
- (void)handleConnectionFailed;

- (void)backgroundThread:(NSThread *)mainThread;
- (NSObject *)getNextPacket;

@end

@implementation KBPSession

@synthesize tag;

- (id)initWithHost:(NSString *)aHost port:(UInt16)aPort delegate:(id<KBPSessionDelegate>)theDelegate {
    if ((self = [super init])) {
        host = aHost;
        port = aPort;
        delegate = theDelegate;
        
        if (![self openSocket]) return nil;
        
        fdLock = [[NSLock alloc] init];
        backgroundThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(backgroundThread:)
                                                     object:[NSThread currentThread]];
        [backgroundThread start];
    }
    return self;
}

- (BOOL)registerTag:(NSData *)aTag {
    if (![self isSocketOpen]) {
        @throw [NSException exceptionWithName:KBPSessionSocketNotOpenException
                                       reason:@"Not connected to proxy server."
                                     userInfo:nil];
    }
    NSDictionary * dictionary = @{@"type": @"tag", @"tag": aTag};
    if (!kb_encode_full_fd(dictionary, fd)) {
        [self handleConnectionFailed];
        return NO;
    }
    isOwner = NO;
    tag = nil;
    return YES;
}

- (BOOL)sendRemoteObject:(NSObject *)data {
    if (![self isSocketOpen]) {
        @throw [NSException exceptionWithName:KBPSessionSocketNotOpenException
                                       reason:@"Not connected to proxy server."
                                     userInfo:nil];
    }
    if (isOwner || !tag) {
        @throw [NSException exceptionWithName:KBPSessionNotConnectedException
                                       reason:@"Not connected to remote client on proxy."
                                     userInfo:nil];
    }
    NSDictionary * dictionary = @{@"type": @"transmit", @"object": data};
    if (!kb_encode_full_fd(dictionary, fd)) {
        [self handleConnectionFailed];
        return NO;
    }
    return YES;
}

- (BOOL)unregisterTag {
    if (![self isSocketOpen]) {
        @throw [NSException exceptionWithName:KBPSessionSocketNotOpenException
                                       reason:@"Not connected to proxy server."
                                     userInfo:nil];
    }
    NSDictionary * dictionary = @{@"type": @"unregister"};
    if (!kb_encode_full_fd(dictionary, fd)) {
        [self handleConnectionFailed];
        return NO;
    }
    isOwner = NO;
    tag = nil;
    return YES;
}

#pragma mark - Connection -

- (BOOL)isSocketOpen {
    int _fd = 0;
    [fdLock lock];
    _fd = fd;
    [fdLock unlock];
    return (_fd >= 0);
}

- (void)closeSocket {
    if (backgroundThread) {
        [backgroundThread cancel];
        backgroundThread = nil;
    }
    [fdLock lock];
    if (fd >= 0) {
        close(fd);
        fd = -1;
    }
    [fdLock unlock];
}

#pragma mark - Private -

- (BOOL)openSocket {
    struct sockaddr_in remoteAddr;
    struct hostent * server;
    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return NO;
    server = gethostbyname([host UTF8String]);
    bzero(&remoteAddr, sizeof(remoteAddr));
    memcpy(&remoteAddr.sin_addr.s_addr, server->h_addr, server->h_length);
    remoteAddr.sin_port = htons(port);
    if (connect(fd, (const struct sockaddr *)&remoteAddr, sizeof(remoteAddr)) < 0) {
        close(fd);
        return NO;
    }
    return YES;
}

- (void)handlePacket:(NSObject *)packet {
    if (![packet isKindOfClass:[NSDictionary class]]) return;
    NSDictionary * dict = (NSDictionary *)packet;
    
    NSString * type = [dict objectForKey:@"type"];
    if (![type isKindOfClass:[NSString class]]) return;
    
    if ([type isEqualToString:@"error"]) {
        if ([delegate respondsToSelector:@selector(kbpSession:remoteError:)]) {
            [delegate kbpSession:self remoteError:dict];
        }
    } else if ([type isEqualToString:@"owned"]) {
        NSData * theTag = [dict objectForKey:@"tag"];
        if (![theTag isKindOfClass:[NSData class]]) return;
        tag = theTag;
        isOwner = YES;
        if ([delegate respondsToSelector:@selector(kbpSessionTagOwned:)]) {
            [delegate kbpSessionTagOwned:self];
        }
    } else if ([type isEqualToString:@"connected"]) {
        NSData * theTag = [dict objectForKey:@"tag"];
        if (![theTag isKindOfClass:[NSData class]]) return;
        tag = theTag;
        isOwner = NO;
        if ([delegate respondsToSelector:@selector(kbpSessionConnected:)]) {
            [delegate kbpSessionConnected:self];
        }
    } else if ([type isEqualToString:@"taken"]) {
        NSData * theTag = [dict objectForKey:@"tag"];
        if (![theTag isKindOfClass:[NSData class]]) return;
        if ([delegate respondsToSelector:@selector(kbpSession:tagTaken:)]) {
            [delegate kbpSession:self tagTaken:theTag];
        }
    } else if ([type isEqualToString:@"incoming"]) {
        NSObject * object = [dict objectForKey:@"object"];
        if ([delegate respondsToSelector:@selector(kbpSession:received:)]) {
            [delegate kbpSession:self received:object];
        }
    }
}

- (void)handleConnectionFailed {
    if (backgroundThread) {
        [backgroundThread cancel];
        backgroundThread = nil;
    }
    [fdLock lock];
    fd = -1;
    [fdLock unlock];
    if (!notifiedClose) {
        notifiedClose = YES;
        if ([delegate respondsToSelector:@selector(kbpSessionSocketClosed:)]) {
            [delegate kbpSessionSocketClosed:self];
        }
    }
}

#pragma mark Background Thread

- (void)backgroundThread:(NSThread *)mainThread {
    while (true) {
        @autoreleasepool {
            NSObject * packet = [self getNextPacket];
            if ([[NSThread currentThread] isCancelled]) return;
            if (!packet) {
                [self performSelector:@selector(handleConnectionFailed)
                             onThread:mainThread
                           withObject:nil
                        waitUntilDone:NO];
                return;
            }
            if ([[NSThread currentThread] isCancelled]) return;
            [self performSelector:@selector(handlePacket:)
                         onThread:mainThread
                       withObject:packet
                    waitUntilDone:NO];
        }
    }
}

- (NSObject *)getNextPacket {
    int _fd = 0;
    [fdLock lock];
    _fd = fd;
    [fdLock unlock];
    return kb_decode_full_fd(fd);
}

@end
