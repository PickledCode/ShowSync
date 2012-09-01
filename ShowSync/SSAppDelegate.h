//
//  SSAppDelegate.h
//  ShowSync
//
//  Created by Alex Nichol on 8/26/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSController.h"
#import "SSPreferencesWindow.h"

@interface SSAppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray * controllers;
    SSPreferencesWindow * prefsWindow;
}

- (void)removeController:(SSController *)controller;
- (IBAction)newWindow:(id)sender;
- (IBAction)preferences:(id)sender;

@end
