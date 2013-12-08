//
//  SSiTunesInterface.h
//  ShowSync
//
//  Created by Ryan Sullivan on 8/27/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <ScriptingBridge/ScriptingBridge.h>
#import "iTunes.h"
#import "SSInterface.h"

@interface SSiTunesInterface : SSInterface {
    iTunesApplication * application;
}

- (void)statusUpdateEvent:(id)sender;

@end
