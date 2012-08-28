//
//  SSMainWindow.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSMainWindow : NSWindow

- (void)handleConnectError:(NSString *)error;
- (void)handleConnecting;
- (void)handleConnected;
- (void)handleDisconnected;
- (void)handleObject:(NSObject *)object;

@end