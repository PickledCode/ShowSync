//
//  SSPreferencesWindow.m
//  ShowSync
//
//  Created by Alex Nichol on 9/1/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSPreferencesWindow.h"

@implementation SSPreferencesWindow

- (id)init {
    NSRect screen = [[NSScreen mainScreen] frame];
    NSRect frame = NSMakeRect((screen.size.width - 200) / 2, (screen.size.width - 46) / 2, 400, 92);
    if ((self = [super initWithContentRect:frame styleMask:(NSTitledWindowMask | NSClosableWindowMask)
                                   backing:NSBackingStoreBuffered defer:NO])) {
        [self setReleasedWhenClosed:NO];
        self.title = @"Preferences";
        
        NSTextField * hostLabel;
        NSTextField * portLabel;
        hostLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frame.size.height - 34, 40, 16)];
        portLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frame.size.height - 64, 40, 16)];
        hostField = [[NSTextField alloc] initWithFrame:NSMakeRect(50, frame.size.height - 38, frame.size.width - 60, 24)];
        portField = [[NSTextField alloc] initWithFrame:NSMakeRect(50, frame.size.height - 68, frame.size.width - 60, 24)];
        
        hostField.stringValue = [[SSPreferencesController sharedController] connectHost];
        hostField.delegate = self;
        [self.contentView addSubview:hostField];
        
        portField.stringValue = [[[SSPreferencesController sharedController] connectPort] stringValue];
        portField.delegate = self;
        [self.contentView addSubview:portField];
        
        hostLabel.stringValue = @"Host:";
        hostLabel.drawsBackground = NO;
        hostLabel.font = [NSFont systemFontOfSize:12];
        [hostLabel setBordered:NO];
        [hostLabel setSelectable:NO];
        [hostLabel setEditable:NO];
        [hostLabel setHidden:NO];
        [self.contentView addSubview:hostLabel];
        
        portLabel.stringValue = @"Port:";
        portLabel.drawsBackground = NO;
        portLabel.font = [NSFont systemFontOfSize:12];
        [portLabel setBordered:NO];
        [portLabel setSelectable:NO];
        [portLabel setEditable:NO];
        [portLabel setHidden:NO];
        [self.contentView addSubview:portLabel];
    }
    return self;
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if (obj.object == hostField) {
        [[SSPreferencesController sharedController] setConnectHost:hostField.stringValue];
    } else {
        [[SSPreferencesController sharedController] setConnectPort:[NSNumber numberWithInt:portField.intValue]];
    }
}

@end
