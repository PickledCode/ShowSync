//
//  SSiTunesInterface.m
//  ShowSync
//
//  Created by Ryan Sullivan on 8/27/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "SSiTunesInterface.h"

@implementation SSiTunesInterface

+ (NSString *)interfaceName {
    return @"iTunes";
}

+ (NSTimeInterval)updateInterval {
    return kSSInterfaceEventInterval;
}

- (id)init {
    if ((self = [super init])) {
        application = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                            selector:@selector(statusUpdateEvent:)
                                                                name:@"com.apple.iTunes.playerInfo"
                                                              object:nil];
    }
    return self;
}

- (void)statusUpdateEvent:(id)sender {
    [self triggerStatusChanged];
}

- (BOOL)isAvailable {
    if (![application isRunning]) return NO;
    // For iTunes to be functional there needs to be a track or something ready to play:
    if (![application currentTrack]) return NO;
    return YES;
}

- (NSTimeInterval)offset {
    if (![self isAvailable]) return 0;
    return [application playerPosition];
}

- (void)setOffset:(NSTimeInterval)offset {
    if (![self isAvailable]) return;
    [application setPlayerPosition:offset];
}

- (BOOL)isPlaying {
    if (![self isAvailable]) return NO;
    return application.playerState == iTunesEPlSPlaying;
}

- (void)setPlaying:(BOOL)playing {
    if (![self isAvailable]) return;
    if ([self isPlaying] == playing) return;
    
    if (playing) {
        [application playOnce:NO];
    } else {
        [application pause];
    }
}

- (void)invalidate {
    [super invalidate];
    application = nil;
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self
                                                               name:@"com.apple.iTunes.playerInfo"
                                                             object:nil];
}

@end
