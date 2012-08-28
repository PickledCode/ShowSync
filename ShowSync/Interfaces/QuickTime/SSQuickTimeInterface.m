//
//  SSQuickTimeInterface.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSQuickTimeInterface.h"

@implementation SSQuickTimeInterface

- (id)init {
    if ((self = [super init])) {
        application = [SBApplication applicationWithBundleIdentifier:@"com.apple.QuickTimePlayerX"];
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
    QuickTimePlayerDocument * document = [[application documents] objectAtIndex:0];
    return document.currentTime;
}

- (void)setOffset:(NSTimeInterval)offset {
    if (![self isAvailable]) return;
    QuickTimePlayerDocument * document = [[application documents] objectAtIndex:0];
    document.currentTime = offset;
}

- (BOOL)isPlaying {
    if (![self isAvailable]) return NO;
    QuickTimePlayerDocument * document = [[application documents] objectAtIndex:0];
    return document.playing;
}

- (void)setPlaying:(BOOL)playing {
    if (![self isAvailable]) return;
    QuickTimePlayerDocument * document = [[application documents] objectAtIndex:0];
    if (document.playing == playing) return;
    if (playing) {
        [document play];
    } else {
        [document pause];
    }
}

@end
