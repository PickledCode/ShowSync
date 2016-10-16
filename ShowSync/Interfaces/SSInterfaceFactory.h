//
//  SSInterfaceFactory.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSVLCInterface.h"
#import "SSQuickTimeInterface.h"
#import "SSPlexMediaPlayerInterface.h"
#import "SSPlexHomeTheaterInterface.h"
#import "SSiTunesInterface.h"

@interface SSInterfaceFactory : NSObject

+ (NSArray *)interfaceClasses;
+ (NSArray *)interfaceNames;
+ (SSInterface *)interfaceWithName:(NSString *)name;

@end
