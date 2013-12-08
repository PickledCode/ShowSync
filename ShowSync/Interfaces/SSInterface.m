//
//  SSInterface.m
//  ShowSync
//
//  Created by Alex Nichol on 12/8/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "SSInterface.h"

@implementation SSInterface

- (id)init {
    if ((self = [super init])) {
        if ([self.class updateInterval] != 0.0) {
            updateTimer = [NSTimer scheduledTimerWithTimeInterval:[self.class updateInterval]
                                                           target:self
                                                         selector:@selector(triggerStatusChanged)
                                                         userInfo:nil repeats:YES];
        }
    }
    return self;
}

- (void)triggerStatusChanged {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(triggerStatusChanged) withObject:nil waitUntilDone:NO];
    } else {
        [self.delegate interfaceStatusChanged:self];
    }
}

+ (NSString *)interfaceName {
    [self doesNotRecognizeSelector:@selector(interfaceName)];
    return nil;
}

+ (NSTimeInterval)updateInterval {
    return kSSInterfacePollingInterval;
}

- (BOOL)isAvailable {
    [self doesNotRecognizeSelector:@selector(isAvailable)];
    return NO;
}

- (NSTimeInterval)offset {
    [self doesNotRecognizeSelector:@selector(offset)];
    return 0;
}

- (void)setOffset:(NSTimeInterval)offset {
    [self doesNotRecognizeSelector:@selector(setOffset:)];
}

- (BOOL)isPlaying {
    [self doesNotRecognizeSelector:@selector(isPlaying)];
    return NO;
}

- (void)setPlaying:(BOOL)playing {
    [self doesNotRecognizeSelector:@selector(setPlaying:)];
}

- (void)invalidate {
    NSAssert(updateTimer != nil || [self.class updateInterval] != 0, @"Invalidate called multiple times?");
    [updateTimer invalidate];
    updateTimer = nil;
}

- (void)dealloc {
    [updateTimer invalidate]; // incase the sub-class is sloppy
}

@end
