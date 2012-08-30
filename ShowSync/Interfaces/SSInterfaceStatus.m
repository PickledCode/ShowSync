//
//  SSInterfaceStatus.m
//  ShowSync
//
//  Created by Alex Nichol on 8/29/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSInterfaceStatus.h"

@implementation SSInterfaceStatus

@synthesize available;
@synthesize playing;
@synthesize offset;

- (id)initUnavailable {
    if ((self = [super init])) {
        available = NO;
    }
    return self;
}

- (id)initWithPlaying:(BOOL)aPlaying offset:(NSTimeInterval)anOffset {
    if ((self = [super init])) {
        available = YES;
        playing = aPlaying;
        offset = anOffset;
    }
    return self;
}

- (id)initWithInterface:(id<SSInterface>)interface {
    if ((self = [super init])) {
        if ([interface isAvailable]) {
            available = YES;
            playing = [interface isPlaying];
            offset = [interface offset];
        } else {
            available = NO;
        }
    }
    return self;
}

- (BOOL)isEqualToStatus:(SSInterfaceStatus*)status {
    // Should we round here?
    return (status.available == self.available &&
            status.playing == self.playing &&
            status.offset == self.offset);
}

#pragma mark - Dictionaries -

- (NSDictionary *)dictionaryRepresentation {
    if (!available) {
        return @{@"available": [NSNumber numberWithBool:NO]};
    } else {
        return @{@"available": [NSNumber numberWithBool:YES],
                 @"playing": [NSNumber numberWithBool:playing],
                 @"offset": [NSNumber numberWithDouble:offset]};
    }
}

+ (SSInterfaceStatus *)interfaceStatusWithDictionaryRepresentation:(NSDictionary *)dictionary {
    BOOL available = [[dictionary objectForKey:@"available"] boolValue];
    if (!available) return [[SSInterfaceStatus alloc] initUnavailable];
    NSTimeInterval offset = [[dictionary objectForKey:@"offset"] doubleValue];
    BOOL playing = [[dictionary objectForKey:@"playing"] boolValue];
    return [[SSInterfaceStatus alloc] initWithPlaying:playing offset:offset];
}

@end
