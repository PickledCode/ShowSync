//
//  SSPlexInterface.h
//  ShowSync
//
//  Created by Alex Nichol on 8/30/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSInterface.h"
#import "SSHTTPRequest.h"
#import <SocketRocket/SRWebSocket.h>

#define kPlexHomeTheaterIdRequestPlayers @(2)
#define kPlexHomeTheaterIdRequestPoll @(3)
#define kPlexHomeTheaterIdRequestPlayPause @(4)
#define kPlexHomeTheaterIdRequestSeek @(5)

@interface SSPlexHomeTheaterInterface : SSInterface <SRWebSocketDelegate> {
    NSString * plexHost;
    
    NSThread * bgThread;
    SRWebSocket * websocket;
    
    BOOL serverActive;
    BOOL serverPlaying;
    NSTimeInterval serverOffset;
    NSNumber *serverPlayerid;
    
    NSTimer *pollTimer;
}

@end
