//
//  SSPlexMediaPlayerInterface.h
//  ShowSync
//
//  Created by Ryan Sullivan on 10/15/16.
//  Copyright © 2016 PickledCode. All rights reserved.
//

#import "SSInterface.h"

// NSURLSessionDataDelegate
@interface SSPlexMediaPlayerInterface : SSInterface <NSURLSessionDelegate> {
    NSString * plexHost;
    NSString * plexRequestIdentifier;

    BOOL serverActive;
    BOOL serverPlaying;
    NSTimeInterval serverOffset;
    NSNumber *serverPlayerid;

    dispatch_queue_t defaultQueue;
    dispatch_queue_t requestQueue;
    BOOL pollRequesting;
    NSTimer *pollTimer;
    NSURLSession *urlSession;
}

@end
