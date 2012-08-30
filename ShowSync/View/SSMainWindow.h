//
//  SSMainWindow.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSConnectView.h"
#import "SSMainView.h"
#import "SSInterfaceStatus.h"

@class SSController;

@interface SSMainWindow : NSWindow {
    __weak SSController * controller;
    
    SSConnectView * connectView;
    SSMainView * mainView;
    NSProgressIndicator * progressIndicator;
    NSTextField * statusField;
    
    BOOL animating;
}

@property (nonatomic, weak) SSController * controller;

- (NSString *)applicationName;

- (void)handleConnectError:(NSString *)error;
- (void)handleConnecting;
- (void)handleConnected;
- (void)handleDisconnected;

- (void)handleRemoteStatus:(SSInterfaceStatus *)status;
- (void)handleLocalStatus:(SSInterfaceStatus *)status;

- (void)connectPressed:(id)sender;
- (void)showConnectView;
- (void)showMainView;

- (void)startLoading;
- (void)stopLoading;

@end
