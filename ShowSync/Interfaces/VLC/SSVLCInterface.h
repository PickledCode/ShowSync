//
//  SSVLCInterface.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <ScriptingBridge/ScriptingBridge.h>
#import "SSInterface.h"
#import "VLC.h"

@interface SSVLCInterface : NSObject <SSInterface> {
    VLCApplication * application;
}

@end
