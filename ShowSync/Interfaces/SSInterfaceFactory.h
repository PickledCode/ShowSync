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
#import "SSPlexInterface.h"
#import "SSiTunesInterface.h"

typedef enum SSInterfaceType {
    SSInterfaceTypeVLC,
    SSInterfaceTypeQuickTime,
    SSInterfaceTypePlex,
    SSInterfaceTypeiTunes
} SSInterfaceType;

@interface SSInterfaceFactory : NSObject

+ (SSInterfaceType)interfaceTypeForString:(NSString *)typeString;
+ (id<SSInterface>)interfaceWithType:(SSInterfaceType)type;

@end
