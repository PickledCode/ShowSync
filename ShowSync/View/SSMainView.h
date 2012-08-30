//
//  SSMainView.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define SSMainViewHeight 148

@interface SSMainView : NSView {
    NSTextField * currentTimeField;
    NSTextField * remoteTimeField;
    NSTextField * pausedField;
    NSTextField * remotePausedField;
    NSButton * takeTimeButton;
    NSButton * pauseAndWaitButton;
    NSButton * syncPausesButton;
}

@property (readonly) NSTextField * currentTimeField;
@property (readonly) NSTextField * remoteTimeField;
@property (readonly) NSTextField * pausedField;
@property (readonly) NSTextField * remotePausedField;
@property (readonly) NSButton * takeTimeButton;
@property (readonly) NSButton * pauseAndWaitButton;
@property (readonly) NSButton * syncPausesButton;

@end
