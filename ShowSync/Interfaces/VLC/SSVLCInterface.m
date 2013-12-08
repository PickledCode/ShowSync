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

- (id)init {
    if ((self = [super init])) {
        application = [SBApplication applicationWithBundleIdentifier:@"org.videolan.vlc"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStateDidChange:) name:@"VLCPlayerStateDidChange" object:nil];
    }
    return self;
}


-(void)playerStateDidChange:(id)sender {
    // Is this even used?
    [self didChangeValueForKey:@"isPlaying"];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    application = nil;
}

@end
