//
//  SSConnectView.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSInterfaceFactory.h"

#define SSConnectViewHeight 78

@interface SSConnectView : NSView {
    NSTextField * tagField;
    NSPopUpButton * playerPopUp;
    NSButton * connectButton;
}

@property (readonly) NSTextField * tagField;
@property (readonly) NSPopUpButton * playerPopUp;
@property (readonly) NSButton * connectButton;

- (id)initWithFrame:(NSRect)frameRect;

@end
