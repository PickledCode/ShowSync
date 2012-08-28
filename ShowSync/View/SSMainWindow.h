//
//  SSMainWindow.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSConnectView.h"

@class SSController;

@interface SSMainWindow : NSWindow {
    __weak SSController * controller;
    
    SSConnectView * connectView;
}

@property (nonatomic, weak) SSController * controller;

- (void)handleConnectError:(NSString *)error;
- (void)handleConnecting;
- (void)handleConnected;
- (void)handleDisconnected;
- (void)handleObject:(NSObject *)object;

@end
