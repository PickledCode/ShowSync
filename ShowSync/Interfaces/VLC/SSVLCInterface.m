//
//  SSVLCInterface.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSVLCInterface.h"

@implementation SSVLCInterface

- (id)init {
    if ((self = [super init])) {
        application = [SBApplication applicationWithBundleIdentifier:@"org.videolan.vlc"];
    }
    return self;
}

- (BOOL)isAvailable {
    if (![application isRunning]) return NO;
    if ([[application documents] count] == 0) return NO;
    return YES;
}

- (NSTimeInterval)offset {
    if (![self isAvailable]) return 0;
    return (NSTimeInterval)[application currentTime];
}

- (void)setOffset:(NSTimeInterval)offset {
    if (![self isAvailable]) return;
    application.currentTime = (NSInteger)offset;
}

- (BOOL)isPlaying {
    if (![self isAvailable]) return NO;
    return application.playing;
}

- (void)setPlaying:(BOOL)playing {
    if (![self isAvailable]) return;
    if (application.playing == playing) return;
    VLCDocument * doc = [[[application windows] objectAtIndex:0] document];
    [doc play];
}

@end
