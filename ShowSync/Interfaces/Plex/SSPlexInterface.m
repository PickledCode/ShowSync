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


NSTimeInterval plexTimeToInterval(NSDictionary * t1) {
    NSTimeInterval hours = [t1[@"hours"] doubleValue];
    NSTimeInterval minutes = [t1[@"minutes"] doubleValue];
    NSTimeInterval seconds = [t1[@"seconds"] doubleValue];
    NSTimeInterval ms = [t1[@"milliseconds"] doubleValue];
    return (ms / 1000.0) + seconds + (minutes * 60) + (hours * 60 * 60);
}
NSDictionary * intervalToPlexTime(NSTimeInterval foo) {
    long long msTime = (long long)(foo * 1000);
    long long ms = msTime % 1000;
    msTime /= 1000;
    long long seconds = msTime % 60;
    msTime /= 60;
    long long minutes = msTime % 60;
    long long hours = msTime / 60;
    return @{@"milliseconds": @(ms), @"seconds": @(seconds),
             @"hours": @(hours), @"minutes": @(minutes)};
}

@implementation SSPlexInterface

+ (NSString *)interfaceName {
    return @"Plex";
}

- (id)init {
    if ((self = [super init])) {
        plexHost = @"http://127.0.0.1:3005";
        
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
            NSDate * doneDate = [NSDate dateWithTimeIntervalSinceNow:0.05];
            
            if ([[NSThread currentThread] isCancelled]) return;
            [self doPendingSets];
            if ([[NSThread currentThread] isCancelled]) return;
            
            // Get plex info
            NSDictionary *sendObject = @{
                @"jsonrpc": @"2.0",
                @"id": @1,
                @"method": @"Player.GetProperties",
                @"params": @[
                    @1,
                    @[
                        @"time",
                        @"totaltime",
                        @"speed"
                    ]
                ]
            };
            NSDictionary *plexData = [SSHTTPRequest postUrl:[self plexUrlWithPath:@"/jsonrpc"] withJsonData:sendObject];
            NSDictionary *result = [plexData objectForKey:@"result"];
            
            BOOL active = result != nil;
            
            if (active && result[@"error"] != nil) {
                active = NO;
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                serverActive = active;
            });
            
            if (active) {
                NSTimeInterval offset = plexTimeToInterval(result[@"time"]);
                BOOL playing = [[result objectForKey:@"speed"] floatValue] > 0;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    serverOffset = offset;
                    serverPlaying = playing;
                });
            }
            
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
    if (playing == serverPlaying) return;
    
    // PlayPause works for now, or we can do SetSpeed
    NSDictionary *sendObject = @{
        @"jsonrpc": @"2.0",
        @"id": @1,
        @"method": @"Player.PlayPause",
        @"params": @[
            @1
        ]
    };
    [SSHTTPRequest postUrl:[self plexUrlWithPath:@"/jsonrpc"] withJsonData:sendObject];
}

- (void)sendSetOffsetRequest:(NSTimeInterval)time {
    // tell plex server the desired offset
    
    NSDictionary *sendObject = @{
        @"jsonrpc": @"2.0",
        @"id": @1,
        @"method": @"Player.Seek",
        @"params": @[
            @1,
            intervalToPlexTime(time)
        ]
    };
    [SSHTTPRequest postUrl:[self plexUrlWithPath:@"/jsonrpc"] withJsonData:sendObject];
}

#pragma mark Helper

-(NSString*)plexUrlWithPath:(NSString*)path {
    // Nothing special
    return [plexHost stringByAppendingString:path];
}

@end
