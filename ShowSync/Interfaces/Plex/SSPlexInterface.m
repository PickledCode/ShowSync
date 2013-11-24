//
//  SSPlexInterface.m
//  ShowSync
//
//  Created by Alex Nichol on 8/30/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSPlexInterface.h"

@interface SSPlexInterface (Private)

- (void)pollServer;
- (void)doPendingSets;

- (void)sendSetPlayingRequest:(BOOL)playing;
- (void)sendSetOffsetRequest:(NSTimeInterval)time;

@end


NSTimeInterval plexTimeToInterval(NSDictionary * t1) {
    NSTimeInterval hours = [t1[@"hours"] doubleValue];
    NSTimeInterval minutes = [t1[@"minutes"] doubleValue];
    NSTimeInterval seconds = [t1[@"seconds"] doubleValue];
    NSTimeInterval ms = [t1[@"milliseconds"] doubleValue];
    return (ms / 1000.0) + seconds + (minutes * 60) + (hours * 60 * 60);
}
NSDictionary * intervalToPlexTime(NSTimeInterval foo) {
    long long msTime = (long long)(foo * 1000);
    long long ms = msTime % 1000;
    msTime /= 1000;
    long long seconds = msTime % 60;
    msTime /= 60;
    long long minutes = msTime % 60;
    long long hours = msTime / 60;
    return @{@"milliseconds": @(ms), @"seconds": @(seconds),
             @"hours": @(hours), @"minutes": @(minutes)};
}


@implementation SSPlexInterface

+ (NSString *)interfaceName {
    return @"Plex";
}

- (id)init {
    if ((self = [super init])) {
        plexHost = @"ws://127.0.0.1:3005/jsonrpc";
        
//        [self startBackground];
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:plexHost]];
        websocket = [[SRWebSocket alloc] initWithURLRequest:req];
        websocket.delegate = self;
        [websocket open];
    }
    return self;
}

- (BOOL)isAvailable {
    return serverActive;
}

- (BOOL)isPlaying {
    return serverPlaying;
}

- (void)setPlaying:(BOOL)playing {
    
}

- (NSTimeInterval)offset {
    return serverOffset;
}

- (void)setOffset:(NSTimeInterval)offset {
    
}

#pragma mark - Thread Control -

//- (void)startBackground {
//    if (bgThread) return;
//    bgThread = [[NSThread alloc] initWithTarget:self
//                                       selector:@selector(pollServer)
//                                         object:nil];
//    [bgThread start];
//}
//
//- (void)stopBackground {
//    [bgThread cancel];
//    bgThread = nil;
//}
//
//- (void)invalidate {
//    [self stopBackground];
//}

#pragma mark - Websocket delegates

// message will either be an NSString if the server is using text
// or NSData if the server is using binary.
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"-webSocket:didReceiveMessage: %@", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"-webSocketDidOpen");
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"-webSocket:DidFailWithError: %@", error);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"-webSocket:didCloseWithCode: %ld reason: %@ wasClean: %d", (long)code, reason, wasClean);
}

@end
