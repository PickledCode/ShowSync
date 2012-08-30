//
//  SSPlexInterface.m
//  ShowSync
//
//  Created by Alex Nichol on 8/30/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSPlexInterface.h"

@interface SSPlexInterface (Private)

- (void)pollServer;
- (void)doPendingSets;

- (void)sendSetPlayingRequest:(BOOL)playing;
- (void)sendSetOffsetRequest:(NSTimeInterval)time;

@end

@implementation SSPlexInterface

- (id)init {
    if ((self = [super init])) {
        // TODO: some sort of info might be supplied here, etc.
        [self startBackground];
        pending = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)isAvailable {
    return serverActive;
}

- (BOOL)isPlaying {
    return serverPlaying;
}

- (void)setPlaying:(BOOL)playing {
    @synchronized (pending) {
        [pending setObject:[NSNumber numberWithBool:playing] forKey:@"playing"];
    }
}

- (NSTimeInterval)offset {
    return serverOffset;
}

- (void)setOffset:(NSTimeInterval)offset {
    @synchronized (pending) {
        [pending setObject:[NSNumber numberWithDouble:offset] forKey:@"offset"];
    }
}

#pragma mark - Thread Control -

- (void)startBackground {
    if (bgThread) return;
    bgThread = [[NSThread alloc] initWithTarget:self
                                       selector:@selector(pollServer)
                                         object:nil];
    [bgThread start];
}

- (void)stopBackground {
    [bgThread cancel];
    bgThread = nil;
}

- (void)invalidate {
    [self stopBackground];
}

#pragma mark - Server -

- (void)pollServer {
    while (true) {
        @autoreleasepool {
            // give 10ms for entire loop
            NSDate * doneDate = [NSDate dateWithTimeIntervalSinceNow:0.01];
            
            if ([[NSThread currentThread] isCancelled]) return;
            [self doPendingSets];
            if ([[NSThread currentThread] isCancelled]) return;
            
            // TODO: fetch info synchronously here
            NSTimeInterval offset = 0;
            BOOL playing = NO;
            BOOL active = NO;
            dispatch_sync(dispatch_get_main_queue(), ^{
                serverOffset = offset;
                serverPlaying = playing;
                serverActive = active;
            });
            
            [NSThread sleepUntilDate:doneDate];
        }
    }
}

- (void)doPendingSets {
    NSArray * keys = nil;
    NSArray * objects = nil;
    @synchronized (pending) {
        if ([[pending allKeys] count] > 0) {
            keys = [pending allKeys];
            objects = [pending objectsForKeys:keys notFoundMarker:[NSNull null]];
            [pending removeAllObjects];
        }
    }
    for (NSUInteger i = 0; i < [keys count]; i++) {
        NSString * key = [keys objectAtIndex:i];
        NSNumber * obj = [objects objectAtIndex:i];
        if ([key isEqualToString:@"playing"]) {
            [self sendSetPlayingRequest:[obj boolValue]];
        } else if ([key isEqualToString:@"offset"]) {
            [self sendSetOffsetRequest:[obj doubleValue]];
        }
        if ([[NSThread currentThread] isCancelled]) return;
    }
}

#pragma mark Requests

- (void)sendSetPlayingRequest:(BOOL)playing {
    // tell plex server that we are playing or paused
}

- (void)sendSetOffsetRequest:(NSTimeInterval)time {
    // tell plex server the desired offset
}

@end
