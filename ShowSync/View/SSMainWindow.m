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
+ (NSString *)stringForTimestamp:(NSTimeInterval)timestamp;

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
        
        mainView.pauseAndWaitButton.target = self;
        mainView.pauseAndWaitButton.action = @selector(waitAndPausePressed:);
        
        mainView.takeTimeButton.target = self;
        mainView.takeTimeButton.action = @selector(takeRemoteOffsetPressed:);
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
        connectView.connectButton.title = @"Cancel";
        [controller registerTag:connectView.tagField.stringValue];
    }
}

- (void)waitAndPausePressed:(id)sender {
    if ([controller.syncController isWaitingForCatchup]) {
        [controller.syncController cancelWaitForCatchup];
        mainView.pauseAndWaitButton.title = @"Pause & Wait";
    } else {
        [controller.syncController waitForCatchup];
        mainView.pauseAndWaitButton.title = @"Cancel Wait";
    }
}

- (void)takeRemoteOffsetPressed:(id)sender {
    [controller.syncController takeTimeFromClient];
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

- (NSString *)applicationName {
    return connectView.playerPopUp.selectedItem.title;
}

- (void)handleConnectError:(NSString *)error {
    [statusField setHidden:NO];
    statusField.stringValue = error;
    [self stopLoading];
    connectView.connectButton.title = @"Connect";
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
    connectView.connectButton.title = @"Connect";
}

#pragma mark - Sync Status -

- (void)handleRemoteStatus:(SSInterfaceStatus *)status {
    if (!status.available) {
        mainView.remotePausedField.stringValue = @"Remote's player is unavailable";
    } else {
        if (status.playing) {
            mainView.remotePausedField.stringValue = @"Remote is playing";
        } else {
            mainView.remotePausedField.stringValue = @"Remote is paused";
        }
        mainView.remoteTimeField.stringValue = [SSMainWindow stringForTimestamp:status.offset];
    }
}

- (void)handleLocalStatus:(SSInterfaceStatus *)status {
    if (!status.available) {
        mainView.pausedField.stringValue = @"Your player is unavailable";
    } else {
        if (status.playing) {
            mainView.pausedField.stringValue = @"You are playing";
        } else {
            mainView.pausedField.stringValue = @"You are paused";
        }
        mainView.currentTimeField.stringValue = [SSMainWindow stringForTimestamp:status.offset];
    }
}

- (void)handleCaughtUp {
    mainView.pauseAndWaitButton.title = @"Pause & Wait";
}

- (BOOL)shouldSyncPauses {
    return mainView.syncPausesButton.state == 1;
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

+ (NSString *)stringForTimestamp:(NSTimeInterval)timestamp {
    int seconds = (int)timestamp % 60;
    int minutes = ((int)timestamp / 60) % 60;
    int hours = (int)timestamp / 60 / 60;
    return [NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds];
}

@end
