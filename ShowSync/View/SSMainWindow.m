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
        [self setReleasedWhenClosed:NO];
        
        connectView = [[SSConnectView alloc] initWithFrame:NSMakeRect(0, 34, size.width, SSConnectViewHeight)];
        [self.contentView addSubview:connectView];
        
        mainView = [[SSMainView alloc] initWithFrame:NSMakeRect(0, 34, size.width, SSMainViewHeight)];
        
        progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(10, 10, size.width - 20, 24)];
        progressIndicator.style = NSProgressIndicatorBarStyle;
        [progressIndicator setDisplayedWhenStopped:YES];
        [progressIndicator setIndeterminate:YES];
        
        statusField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, size.width - 20, 24)];
        statusField.stringValue = @"";
        statusField.drawsBackground = NO;
        statusField.font = [NSFont systemFontOfSize:11];
        [statusField setBordered:NO];
        [statusField setSelectable:NO];
        [statusField setEditable:NO];
        [statusField setHidden:NO];
        [self.contentView addSubview:statusField];
        
        connectView.connectButton.target = self;
        connectView.connectButton.action = @selector(connectPressed:);        
    }
    return self;
}

- (void)orderOut:(id)sender {
    [super orderOut:sender];
    [controller viewClosed];
}

#pragma mark - Actions -

- (void)connectPressed:(id)sender {
    if ([controller isRegistered]) {
        [self stopLoading];
        [controller unregister];
        connectView.connectButton.title = @"Connect";
    } else {
        if ([connectView.tagField.stringValue length] == 0) {
            // TODO: make this modal
            NSRunAlertPanel(@"Invalid Tag",
                            @"You must enter a tag before connecting to the KBProxy.",
                            @"OK", nil, nil);
            return;
        }
        [self startLoading];
        [statusField setHidden:YES];
        [controller registerTag:connectView.tagField.stringValue];
        connectView.connectButton.title = @"Cancel";
    }
}

#pragma mark - Transitions -

- (void)showConnectView {
    if ([connectView superview]) return;
    [mainView removeFromSuperview];
    NSRect frame = self.frame;
    frame.size.height += (SSConnectViewHeight - SSMainViewHeight);
    frame.origin.y -= (SSConnectViewHeight - SSMainViewHeight);
    [self setFrame:frame display:YES animate:YES];
    [self.contentView addSubview:connectView];
}

- (void)showMainView {
    if ([mainView superview]) return;
    [connectView removeFromSuperview];
    NSRect frame = self.frame;
    frame.size.height += (SSMainViewHeight - SSConnectViewHeight);
    frame.origin.y -= (SSMainViewHeight - SSConnectViewHeight);
    [self setFrame:frame display:YES animate:YES];
    [self.contentView addSubview:mainView];
}

- (void)startLoading {
    if (![progressIndicator superview]) {
        [self.contentView addSubview:progressIndicator];
        [progressIndicator startAnimation:self];
    }
}

- (void)stopLoading {
    if ([progressIndicator superview]) {
        [progressIndicator stopAnimation:self];
        [progressIndicator removeFromSuperview];
    }
}

#pragma mark - Controller -

- (void)handleConnectError:(NSString *)error {
    [statusField setHidden:NO];
    statusField.stringValue = error;
    [self stopLoading];
}

- (void)handleConnecting {
    if ([mainView superview]) {
        [self showConnectView];
        [self startLoading];
        [statusField setHidden:YES];
    }
}

- (void)handleConnected {
    NSLog(@"Connected, bitchesss");
    [self showMainView];
    [self stopLoading];
    [statusField setHidden:YES];
}

- (void)handleDisconnected {
    NSLog(@"Disconnected, bitchesss");
    [self showConnectView];
    [self stopLoading];
    
    statusField.stringValue = @"Disconnected.";
    [statusField setHidden:NO];
    
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
