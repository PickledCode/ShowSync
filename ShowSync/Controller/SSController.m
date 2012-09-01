//
//  SSController.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSController.h"
#import "SSAppDelegate.h"

@implementation SSController

@synthesize window;
@synthesize syncController;
@synthesize session;

- (id)initWithWindow:(SSMainWindow *)aWindow {
    if ((self = [super init])) {
        window = aWindow;
    }
    return self;
}

- (BOOL)isRegistered {
    return ([session tag] != nil);
}

- (void)registerTag:(NSString *)tag {
    if (!session) {
        SSPreferencesController * prefs = [SSPreferencesController sharedController];
        if (![prefs connectHost]) [prefs setConnectHost:SSDefaultServer];
        if (![prefs connectPort]) [prefs setConnectPort:@SSDefaultPort];
        NSString * host = [prefs connectHost];
        int port = [[prefs connectPort] intValue];
        
        session = [[KBPSession alloc] initWithHost:host
                                              port:port
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
        window = nil;
    }
    [((SSAppDelegate *)[NSApplication sharedApplication].delegate) removeController:self];
}

#pragma mark - KBProxy Delegate -

- (void)kbpSessionTagOwned:(KBPSession *)session {
    [window handleConnecting];
    [syncController invalidate];
    syncController = nil;
}

- (void)kbpSessionSocketClosed:(KBPSession *)aSession {
    [syncController invalidate];
    syncController = nil;
    [window handleDisconnected];
    session = nil;
}

- (void)kbpSessionConnected:(KBPSession *)session {
    syncController = [[SSSyncController alloc] initWithController:self];
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
    if ([object isKindOfClass:[NSDictionary class]]) {
        [syncController handleObject:(NSDictionary *)object];
    }
}

@end
