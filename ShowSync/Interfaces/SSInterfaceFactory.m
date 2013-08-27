//
//  SSInterfaceFactory.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSInterfaceFactory.h"

@implementation SSInterfaceFactory

+ (SSInterfaceType)interfaceTypeForString:(NSString *)typeString {
    struct {
        __unsafe_unretained NSString * name;
        SSInterfaceType type;
    } types[] = {
        {@"VLC", SSInterfaceTypeVLC},
        {@"QuickTime", SSInterfaceTypeQuickTime},
        {@"Plex", SSInterfaceTypePlex},
        {@"iTunes", SSInterfaceTypeiTunes}
    };
    for (int i = 0; i < 3; i++) {
        if ([types[i].name isEqualToString:typeString]) {
            return types[i].type;
        }
    }
    return 0;
}

+ (id<SSInterface>)interfaceWithType:(SSInterfaceType)type {
    Class c = Nil;
    switch (type) {
        case SSInterfaceTypeVLC:
            c = [SSVLCInterface class];
            break;
        case SSInterfaceTypeQuickTime:
            c = [SSQuickTimeInterface class];
            break;
        case SSInterfaceTypePlex:
            c = [SSPlexInterface class];
            break;
        case SSInterfaceTypeiTunes:
            c = [SSiTunesInterface class];
            break;
        default:
            break;
    }
    if (c == Nil) return nil;
    return [[c alloc] init];
}

@end
