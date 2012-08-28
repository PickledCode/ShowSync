//
//  SSController.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSController.h"

@implementation SSController

@synthesize window;

- (id)initWithWindow:(SSMainWindow *)aWindow {
    if ((self = [super init])) {
        window = aWindow;
    }
    return self;
}

- (void)registerTag:(NSString *)tag {
    if (!session) {
        session = [[KBPSession alloc] initWithHost:SSDefaultServer
                                              port:SSDefaultPort
                                          delegate:self];
        if (!session) {
            [window handleConnectError:@"Cannot connect to server."];
            return;
        }
    }
    [session registerTag:[tag dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)unregister {
    [session unregisterTag];
}

- (void)viewClosed {
    if ([session isSocketOpen]) {
        [session closeSocket];
        session = nil;
    }
}

#pragma mark - KBProxy Delegate -

- (void)kbpSessionTagOwned:(KBPSession *)session {
    [window handleConnecting];
}

- (void)kbpSessionSocketClosed:(KBPSession *)aSession {
    [window handleDisconnected];
    session = nil;
}

- (void)kbpSessionConnected:(KBPSession *)session {
    [window handleConnected];
}

- (void)kbpSession:(KBPSession *)session tagTaken:(NSData *)tag {
    [window handleConnectError:@"Tag already in use."];
}

- (void)kbpSession:(KBPSession *)session remoteError:(NSDictionary *)error {
    // TODO: handle error here
    NSLog(@"got remote error: %@", error);
}

- (void)kbpSession:(KBPSession *)session received:(NSObject *)object {
    
}

@end
