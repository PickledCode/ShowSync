//
//  SSConnectView.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSConnectView.h"

@implementation SSConnectView

@synthesize tagField;
@synthesize playerPopUp;
@synthesize connectButton;

- (id)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect])) {
        NSTextField * tagLabel;
        NSTextField * playerLabel;
        
        CGFloat labelWidth = 45;
        
        tagLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frameRect.size.height - 29, labelWidth, 16)];
        tagLabel.drawsBackground = NO;
        tagLabel.stringValue = @"Tag:";
        tagLabel.alignment = NSLeftTextAlignment;
        [tagLabel setBordered:NO];
        [tagLabel setEditable:NO];
        [tagLabel setSelectable:NO];
        [self addSubview:tagLabel];
        
        playerLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frameRect.size.height - 63, labelWidth, 16)];
        playerLabel.drawsBackground = NO;
        playerLabel.stringValue = @"Player:";
        playerLabel.alignment = NSLeftTextAlignment;
        [playerLabel setBordered:NO];
        [playerLabel setEditable:NO];
        [playerLabel setSelectable:NO];
        [self addSubview:playerLabel];
        
        tagField = [[NSTextField alloc] initWithFrame:NSMakeRect(labelWidth + 12, frameRect.size.height - 34, frameRect.size.width - (labelWidth + 12 + 10), 24)];
        tagField.bezelStyle = NSTextFieldSquareBezel;
        [tagField setEditable:YES];
        [self addSubview:tagField];
        
        playerPopUp = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(labelWidth + 10, frameRect.size.height - 68, 150, 24)];
        [playerPopUp addItemsWithTitles:[SSInterfaceFactory interfaceNames]];
        [self addSubview:playerPopUp];
        
        connectButton = [[NSButton alloc] initWithFrame:NSMakeRect(frameRect.size.width - 95, frameRect.size.height - 68, 90, 24)];
        connectButton.bezelStyle = NSRoundedBezelStyle;
        connectButton.font = [NSFont systemFontOfSize:13];
        connectButton.title = @"Connect";
        [self addSubview:connectButton];
    }
    return self;
}

@end
