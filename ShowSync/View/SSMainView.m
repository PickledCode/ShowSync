//
//  SSMainView.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSMainView.h"

@implementation SSMainView

@synthesize currentTimeField;
@synthesize remoteTimeField;
@synthesize pausedField;
@synthesize remotePausedField;
@synthesize takeTimeButton;
@synthesize pauseAndWaitButton;
@synthesize syncPausesButton;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        NSTextField * currentTimeLabel = nil;
        NSTextField * remoteTimeLabel = nil;
        
        currentTimeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frame.size.height - 26, 100, 16)];
        currentTimeLabel.drawsBackground = NO;
        currentTimeLabel.stringValue = @"Time:";
        currentTimeLabel.alignment = NSLeftTextAlignment;
        [currentTimeLabel setBordered:NO];
        [currentTimeLabel setEditable:NO];
        [currentTimeLabel setSelectable:NO];
        [self addSubview:currentTimeLabel];
        
        remoteTimeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frame.size.height - 52, 100, 16)];
        remoteTimeLabel.drawsBackground = NO;
        remoteTimeLabel.stringValue = @"Remote Time:";
        remoteTimeLabel.alignment = NSLeftTextAlignment;
        [remoteTimeLabel setBordered:NO];
        [remoteTimeLabel setEditable:NO];
        [remoteTimeLabel setSelectable:NO];
        [self addSubview:remoteTimeLabel];
        
        currentTimeField = [[NSTextField alloc] initWithFrame:NSMakeRect(120, frame.size.height - 26, frame.size.width - 130, 16)];
        currentTimeField.drawsBackground = NO;
        currentTimeField.stringValue = @"0:00:00";
        currentTimeField.alignment = NSLeftTextAlignment;
        [currentTimeField setBordered:NO];
        [currentTimeField setEditable:NO];
        [currentTimeField setSelectable:NO];
        [self addSubview:currentTimeField];
        
        remoteTimeField = [[NSTextField alloc] initWithFrame:NSMakeRect(120, frame.size.height - 52, frame.size.width - 130, 16)];
        remoteTimeField.drawsBackground = NO;
        remoteTimeField.stringValue = @"0:00:00";
        remoteTimeField.alignment = NSLeftTextAlignment;
        [remoteTimeField setBordered:NO];
        [remoteTimeField setEditable:NO];
        [remoteTimeField setSelectable:NO];
        [self addSubview:remoteTimeField];
        
        pausedField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frame.size.height - 78, frame.size.width - 130, 16)];
        pausedField.drawsBackground = NO;
        pausedField.stringValue = @"You are paused";
        pausedField.alignment = NSLeftTextAlignment;
        [pausedField setBordered:NO];
        [pausedField setEditable:NO];
        [pausedField setSelectable:NO];
        [self addSubview:pausedField];
        
        remotePausedField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frame.size.height - 104, frame.size.width - 130, 16)];
        remotePausedField.drawsBackground = NO;
        remotePausedField.stringValue = @"Remote is paused";
        remotePausedField.alignment = NSLeftTextAlignment;
        [remotePausedField setBordered:NO];
        [remotePausedField setEditable:NO];
        [remotePausedField setSelectable:NO];
        [self addSubview:remotePausedField];
        
        takeTimeButton = [[NSButton alloc] initWithFrame:NSMakeRect(frame.size.width - 125, frame.size.height - 138, 120, 24)];
        takeTimeButton.bezelStyle = NSRoundedBezelStyle;
        takeTimeButton.font = [NSFont systemFontOfSize:13];
        takeTimeButton.title = @"Take Time";
        [self addSubview:takeTimeButton];
        
        pauseAndWaitButton = [[NSButton alloc] initWithFrame:NSMakeRect(frame.size.width - 245, frame.size.height - 138, 120, 24)];
        pauseAndWaitButton.bezelStyle = NSRoundedBezelStyle;
        pauseAndWaitButton.font = [NSFont systemFontOfSize:13];
        pauseAndWaitButton.title = @"Pause & Wait";
        [self addSubview:pauseAndWaitButton];
        
        syncPausesButton = [[NSButton alloc] initWithFrame:NSMakeRect(10, frame.size.height - 138, 100, 24)];
        syncPausesButton.state = 1;
        [syncPausesButton setButtonType:NSSwitchButton];
        syncPausesButton.title = @"Sync pauses";
        [self addSubview:syncPausesButton];
    }
    return self;
}

@end
