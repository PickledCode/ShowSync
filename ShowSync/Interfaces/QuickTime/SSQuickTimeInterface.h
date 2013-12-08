//
//  SSQuickTimeInterface.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <ScriptingBridge/ScriptingBridge.h>
#import "QuickTimePlayer.h"
#import "SSInterface.h"

@interface SSQuickTimeInterface : SSInterface {
    QuickTimePlayerApplication * application;
}

@end
