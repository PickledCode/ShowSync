//
//  SSMainWindow.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSMainWindow.h"
#import "SSController.h"

@interface SSMainWindow (Private)

+ (NSRect)centerFrameOnScreen:(NSRect)frame;

@end

@implementation SSMainWindow

@synthesize controller;

- (id)init {
    NSSize size = NSMakeSize(400, SSConnectViewHeight + 34);
    NSRect frame = [SSMainWindow centerFrameOnScreen:NSMakeRect(0, 0, size.width, size.height)];
    if ((self = [super initWithContentRect:frame
                                 styleMask:(NSTitledWindowMask | NSClosableWindowMask)
                                   backing:NSBackingStoreBuffered
                                     defer:NO])) {
        connectView = [[SSConnectView alloc] initWithFrame:NSMakeRect(0, 34, size.width, SSConnectViewHeight)];
        [self.contentView addSubview:connectView];
    }
    return self;
}

- (void)handleConnectError:(NSString *)error {
    
}

- (void)handleConnecting {
    
}

- (void)handleConnected {
    
}

- (void)handleDisconnected {
    
}

- (void)handleObject:(NSObject *)object {
    NSLog(@"got object: %@", object);
}

#pragma mark - Private -

+ (NSRect)centerFrameOnScreen:(NSRect)frame {
    NSScreen * screen = [NSScreen mainScreen];
    NSRect screenFrame = screen.frame;
    NSRect newFrame = frame;
    newFrame.origin.x = round((screenFrame.size.width - frame.size.width) / 2);
    newFrame.origin.y = round((screenFrame.size.height - frame.size.height) / 2);
    return newFrame;
}

@end
