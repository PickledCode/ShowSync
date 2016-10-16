//
//  SSPlexMediaPlayerInterface.m
//  ShowSync
//
//  Created by Ryan Sullivan on 10/15/16.
//  Copyright © 2016 PickledCode. All rights reserved.
//

#import "SSPlexMediaPlayerInterface.h"

@interface SSPlexMediaPlayerInterface (Private)

- (void)requestPoll;

@end


@implementation SSPlexMediaPlayerInterface

+ (NSString *)interfaceName {
    return @"Plex Media Player";
}

- (id)init {
    if ((self = [super init])) {
        plexHost = @"http://127.0.0.1:32433/";
        plexRequestIdentifier = [NSUUID UUID].UUIDString;

        defaultQueue = dispatch_get_current_queue();

        urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:nil];

        pollTimer = [NSTimer scheduledTimerWithTimeInterval:kSSInterfacePollingInterval
                                                     target:self
                                                   selector:@selector(requestPoll)
                                                   userInfo:nil
                                                    repeats:YES];
        [pollTimer fire];
    }
    return self;
}

- (NSMutableURLRequest*)baseRequest {
    NSMutableURLRequest *req = [NSMutableURLRequest new];
    [req setAllHTTPHeaderFields:@{
        @"X-Plex-Platform": @"randomApiValue",
        @"X-Plex-Platform-Version": @"randomApiValue",
        @"X-Plex-Provides": @"controller",
        @"X-Plex-Product": @"randomApiValue",
        @"X-Plex-Version": @"randomApiValue",
        @"X-Plex-Device": @"randomApiValue",
        @"X-Plex-Device-Name": @"randomApiValue",
        @"X-Plex-Client-Identifier": plexRequestIdentifier,
    }];
    return req;
}

- (void)requestPoll {
    NSLog(@"Making a request");
    NSURLComponents *url = [NSURLComponents componentsWithString:plexHost];
    [url setPath:@"/player/timeline/poll"];
    [url setQuery:@"wait=0&commandID=1"];

    NSMutableURLRequest *req = [self baseRequest];
    [req setURL:[url URL]];
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"I am in competion handler!!!");
        NSLog(@"%@", response);
        NSString *ds = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", ds);
    }];
    [task resume];
}

#pragma mark - NSURLSessionDelegate methods

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
}

#pragma mark - NSURLSessionTaskDelegate methods

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
}

#pragma mark - Interface methods

- (BOOL)isAvailable {
    return NO;
}

- (NSTimeInterval)offset {
    return 0;
}

- (void)setOffset:(NSTimeInterval)offset {
}

- (BOOL)isPlaying {
    return NO;
}

- (void)setPlaying:(BOOL)playing {

}


@end
