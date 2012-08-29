//
//  KBPSession.h
//  KBProxyTest
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBDecodeObjC.h"
#import "KBEncodeObjC.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>

@class KBPSession;

@protocol KBPSessionDelegate <NSObject>

@optional
- (void)kbpSession:(KBPSession *)session tagTaken:(NSData *)tag;
- (void)kbpSessionTagOwned:(KBPSession *)session;
- (void)kbpSessionConnected:(KBPSession *)session;
- (void)kbpSession:(KBPSession *)session received:(NSObject *)object;
- (void)kbpSession:(KBPSession *)session remoteError:(NSDictionary *)error;
- (void)kbpSessionSocketClosed:(KBPSession *)session;

@end

#define KBPSessionNotConnectedException @"KBPSessionNotConnectedException"
#define KBPSessionSocketNotOpenException @"KBPSessionSocketNotOpenException"

@interface KBPSession : NSObject {
    NSString * host;
    UInt16 port;
    __weak id<KBPSessionDelegate> delegate;
    
    NSThread * backgroundThread;
    int fd;
    NSLock * fdLock;
    BOOL notifiedClose;
    
    NSData * tag;
    BOOL isOwner;
}

@property (readonly) NSData * tag;

- (id)initWithHost:(NSString *)aHost port:(UInt16)aPort delegate:(id<KBPSessionDelegate>)theDelegate;

- (BOOL)registerTag:(NSData *)tag;
- (BOOL)sendRemoteObject:(NSObject *)data;
- (BOOL)unregisterTag;

- (BOOL)isSocketOpen;
- (void)closeSocket;

@end
