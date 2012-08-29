//
//  SSAppDelegate.m
//  ShowSync
//
//  Created by Alex Nichol on 8/26/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSAppDelegate.h"

@implementation SSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    controllers = [[NSMutableArray alloc] init];
    [self newWindow:nil];
}

- (void)removeController:(SSController *)controller {
    [controllers removeObject:controller];
}

- (IBAction)newWindow:(id)sender {
    SSMainWindow * window = [[SSMainWindow alloc] init];
    SSController * controller = [[SSController alloc] initWithWindow:window];
    window.controller = controller;
    [controllers addObject:controller];
    [window makeKeyAndOrderFront:self];
}

@end
