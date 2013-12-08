//
//  SSInterfaceFactory.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSInterfaceFactory.h"

@implementation SSInterfaceFactory

+ (NSArray *)interfaceClasses {
    return @[[SSVLCInterface class], [SSQuickTimeInterface class], [SSPlexInterface class], [SSiTunesInterface class]];
}

+ (NSArray *)interfaceNames {
    NSMutableArray * names = [NSMutableArray array];
    for (Class aClass in [self interfaceClasses]) {
        [names addObject:[aClass interfaceName]];
    }
    return [names copy]; // copy it to make it immutable
}

+ (SSInterface *)interfaceWithName:(NSString *)name {
    Class class = Nil;
    for (Class aClass in [self interfaceClasses]) {
        if ([[aClass interfaceName] isEqualToString:name]) {
            class = aClass;
            break;
        }
    }
    if (class == Nil) return nil;
    return [[class alloc] init];
}

@end
