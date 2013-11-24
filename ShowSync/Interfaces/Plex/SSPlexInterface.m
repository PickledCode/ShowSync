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
        plexHost = @"ws://127.0.0.1:9090/jsonrpc";
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:plexHost]];
        websocket = [[SRWebSocket alloc] initWithURLRequest:req];
        websocket.delegate = self;
        [websocket open];
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
    if (playing == serverPlaying) return;
    
    NSDictionary *send = @{
        @"method": @"Player.PlayPause",
        @"params": @{}
    };
    [self sendWebsocket:send];
}

- (NSTimeInterval)offset {
    return serverOffset;
}

- (void)setOffset:(NSTimeInterval)offset {
    NSDictionary *send = @{
        @"method": @"Player.Seek",
        @"params": @{
            @"time": intervalToPlexTime(offset)
        }
    };
    [self sendWebsocket:send];
}

-(void)invalidate {
    if (pollTimer) [pollTimer invalidate], pollTimer = nil;
    [websocket close];
}

#pragma mark - Websocket delegates

-(void)sendWebsocket:(NSDictionary*)json {
    NSMutableDictionary *newJson = [NSMutableDictionary dictionaryWithDictionary:json];
    [newJson setObject:@"2.0" forKey:@"jsonrpc"];
    return [websocket send:[NSJSONSerialization dataWithJSONObject:newJson options:0 error:nil]];
}

- (void)requestPoll:(id)sender {
    NSLog(@"-requestPoll");
    if (!serverPlayerid) return;
    
    NSDictionary *json = @{
        @"id": @2,
        @"method": @"Player.GetProperties",
        @"params": @{
            @"playerid": serverPlayerid,
            @"properties": @[
                @"time",
                @"speed"
            ]
        }
    };
    [self sendWebsocket:json];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"-webSocket:didReceiveMessage: (see below)");
    
    // message will either be an NSString if the server is using text
    // or NSData if the server is using binary.
    NSData *msgData = nil;
    if ([message isKindOfClass:[NSString class]]) {
        msgData = [(NSString*)message dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([message isKindOfClass:[NSData class]]) {
        msgData = message;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:msgData options:0 error:nil];
    NSLog(@"JSON: %@", json);
    
    NSString *method = json[@"method"];
    NSArray *methodParts = [method componentsSeparatedByString:@"."];
    
    NSString *sender = json[@"params"][@"sender"];
    if (sender && ![sender isEqualToString:@"xbmc"])
    {
        NSLog(@"Unknown sender: %@", sender);
        return;
    }
    
    if (json[@"id"] && json[@"result"])
    {
        if ([json[@"id"] isEqualToNumber:@2])
        {
            if (json[@"result"][@"time"])
            {
                serverOffset = plexTimeToInterval(json[@"result"][@"time"]);
            }
            if (json[@"result"][@"speed"])
            {
                serverPlaying = [json[@"result"][@"speed"] floatValue] > 0;
            }
        }
        else if ([json[@"id"] isEqualToNumber:@3])
        {
            serverPlayerid = json[@"result"][0][@"playerid"];
        }
    }
    else if ([methodParts[0] isEqualToString:@"Player"])
    {
        // Handle play/pause state
        if ([methodParts[1] isEqualToString:@"OnPlay"])
        {
            serverPlaying = YES;
        }
        else if ([methodParts[1] isEqualToString:@"OnPause"] ||
                 [methodParts[1] isEqualToString:@"OnStop"])
        {
            serverPlaying = NO;
        }
        else if ([methodParts[1] isEqualToString:@"OnSpeedChanged"])
        {
            // TODO
        }
        
        // Handle user seeking
        else if ([methodParts[1] isEqualToString:@"OnSeek"])
        {
            serverOffset = plexTimeToInterval(json[@"params"][@"data"][@"player"][@"time"]);
        }

    }
    else if ([methodParts[0] isEqualToString:@"System"])
    {
        if ([methodParts[1] isEqualToString:@"OnQuit"])
        {
            serverActive = NO;
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"-webSocketDidOpen");
    serverActive = YES;
    
    NSDictionary *json = @{
        @"id": @3,
        @"method": @"Player.GetActivePlayers"
    };
    [self sendWebsocket:json];

    pollTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestPoll:) userInfo:nil repeats:YES];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"-webSocket:DidFailWithError: %@", error);
    serverActive = NO;
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"-webSocket:didCloseWithCode: %ld reason: %@ wasClean: %d", (long)code, reason, wasClean);
    serverActive = NO;
}

@end
