//
//  SSVLCInterface.m
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSVLCInterface.h"

@implementation SSVLCInterface

+ (NSString *)interfaceName {
    return @"VLC";
}

+ (NSTimeInterval)updateInterval {
    return kSSInterfaceEventInterval;
}

- (id)init {
    if ((self = [super init])) {
        application = [SBApplication applicationWithBundleIdentifier:@"org.videolan.vlc"];
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                            selector:@selector(playerStateDidChange:)
                                                                name:@"VLCPlayerStateDidChange"
                                                              object:nil];
    }
    return self;
}

- (BOOL)isAvailable {
    if (![application isRunning]) return NO;
    if ([[application windows] count] == 0) return NO;
    if (![[[application windows] objectAtIndex:0] document]) return NO;
    if ([application currentTime] < 0) return NO;
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

- (void)invalidate {
    [super invalidate];
    application = nil;
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self
                                                               name:@"VLCPlayerStateDidChange"
                                                             object:nil];
}

- (void)playerStateDidChange:(id)note {
    [self triggerStatusChanged];
}

@end
