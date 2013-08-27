//
//  SSiTunesInterface.m
//  ShowSync
//
//  Created by Ryan Sullivan on 8/27/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "SSiTunesInterface.h"

@implementation SSiTunesInterface

- (id)init {
    if ((self = [super init])) {
        application = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    }
    return self;
}

-(BOOL)isAvailable {
    if (![application isRunning]) return NO;
    // For iTunes to be functional there needs to be a track or something ready to play:
    if (![application currentTrack]) return NO;
    return YES;
}

-(NSTimeInterval)offset {
    if (![self isAvailable]) return 0;
    return [application playerPosition];
}

-(void)setOffset:(NSTimeInterval)offset {
    if (![self isAvailable]) return;
    [application setPlayerPosition:offset];
}

-(BOOL)isPlaying {
    if (![self isAvailable]) return NO;
    return application.playerState == iTunesEPlSPlaying;
}

-(void)setPlaying:(BOOL)playing {
    if (![self isAvailable]) return;
    if ([self isPlaying] == playing) return;
    
    if (playing) {
        [application playOnce:YES];
    } else {
        [application pause];
    }
}

//- (BOOL)isAvailable {
//    if (![application isRunning]) return NO;
//    if ([[application documents] count] == 0) return NO;
//    return YES;
//}

//- (NSTimeInterval)offset {
//    if (![self isAvailable]) return 0;
//    QuickTimePlayerDocument * document = [[application documents] objectAtIndex:0];
//    return document.currentTime;
//}

//- (void)setOffset:(NSTimeInterval)offset {
//    if (![self isAvailable]) return;
//    QuickTimePlayerDocument * document = [[application documents] objectAtIndex:0];
//    document.currentTime = offset;
//}

//- (BOOL)isPlaying {
//    if (![self isAvailable]) return NO;
//    QuickTimePlayerDocument * document = [[application documents] objectAtIndex:0];
//    return document.playing;
//}

//- (void)setPlaying:(BOOL)playing {
//    if (![self isAvailable]) return;
//    QuickTimePlayerDocument * document = [[application documents] objectAtIndex:0];
//    if (document.playing == playing) return;
//    if (playing) {
//        [document play];
//    } else {
//        [document pause];
//    }
//}

- (void)invalidate {
    application = nil;
}

@end
