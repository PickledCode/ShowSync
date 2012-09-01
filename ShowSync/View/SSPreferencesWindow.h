//
//  SSPreferencesWindow.h
//  ShowSync
//
//  Created by Alex Nichol on 9/1/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSPreferencesController.h"

@interface SSPreferencesWindow : NSWindow <NSTextFieldDelegate> {
    NSTextField * hostField;
    NSTextField * portField;
}

@end
