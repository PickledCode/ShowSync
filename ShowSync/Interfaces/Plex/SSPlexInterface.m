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

+ (NSString *)interfaceName {
    return @"Plex";
}

- (id)init {
    if ((self = [super init])) {
        plexHost = @"http://127.0.0.1:3000";
        
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
            
            // Get plex info
            NSDictionary *sendObject = @{@"jsonrpc": @"2.0", @"method": @"VideoPlayer.GetTimeMS", @"id": @1};
            NSDictionary *plexData = [SSHTTPRequest postUrl:[self plexUrlWithPath:@"/jsonrpc"] withJsonData:sendObject];
            NSDictionary *result = [plexData objectForKey:@"result"];
            
            NSTimeInterval offset = (NSTimeInterval)([[result objectForKey:@"time"] doubleValue]/1000);
            BOOL playing = ![[result objectForKey:@"paused"] boolValue];
            BOOL active = [[result objectForKey:@"playing"] boolValue];
            
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
//    var method = this.activePlayer + ((this.playing || this.paused) ? 'Player.PlayPause' : 'Playlist.Play');
//    jQuery.post(JSON_RPC + '?PlayPause', '{"jsonrpc": "2.0", "method": "' + method + '", "id": 1}', jQuery.proxy(function(data) {
//        if (data && data.result) {
//            this.playing = data.result.playing;
//            this.paused = data.result.paused;
//            if (this.playing) {
//                this.showPauseButton();
//            } else {
//                this.showPlayButton();
//            }
//        }
//    }, this), 'json');
    
    // tell plex server that we are playing or paused
    if (playing == serverPlaying) return;
    
    NSString *method = @"VideoPlayer.PlayPause";
    NSDictionary *sendObject = @{@"jsonrpc": @"2.0", @"method": method, @"id": @1};
    [SSHTTPRequest postUrl:[self plexUrlWithPath:@"/jsonrpc"] withJsonData:sendObject];
}

- (void)sendSetOffsetRequest:(NSTimeInterval)time {
    // tell plex server the desired offset
    
    NSNumber *sendTime = [NSNumber numberWithDouble:round(time)];
    NSDictionary *sendObject = @{@"jsonrpc": @"2.0", @"method": @"VideoPlayer.SeekTime", @"params": sendTime, @"id": @1};
    [SSHTTPRequest postUrl:[self plexUrlWithPath:@"/jsonrpc"] withJsonData:sendObject];
}

#pragma mark Helper

-(NSString*)plexUrlWithPath:(NSString*)path {
    // Nothing special
    return [plexHost stringByAppendingString:path];
}

@end
