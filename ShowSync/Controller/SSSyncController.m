//
//  SSSyncController.m
//  ShowSync
//
//  Created by Alex Nichol on 8/29/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSSyncController.h"
#import "SSController.h"

@interface SSSyncController (Private)

- (void)playIfCaughtUp;

@end

@implementation SSSyncController

- (id)initWithController:(SSController *)aController {
    if ((self = [super init])) {
        controller = aController;
        
        // create the interface based on user application drop-down
        NSString * interfaceName = aController.window.applicationName;
        SSInterfaceType type = [SSInterfaceFactory interfaceTypeForString:interfaceName];
        interface = [SSInterfaceFactory interfaceWithType:type];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(sendTimestampAndPausedInfo:)
                                               userInfo:nil
                                                repeats:YES];
    }
    return self;
}

- (void)handleObject:(NSDictionary *)object {
    if ([[object objectForKey:@"type"] isEqualToString:@"status"]) {
        NSDictionary * dict = [object objectForKey:@"status"];
        if (![dict isKindOfClass:[NSDictionary class]]) return;
        
        SSInterfaceStatus * status = [SSInterfaceStatus interfaceStatusWithDictionaryRepresentation:dict];
        [controller.window handleRemoteStatus:status];
        
        BOOL playPauseChanged = NO;
        if (remoteStatus && remoteStatus.available && status.available) {
            if (remoteStatus.playing != status.playing) {
                playPauseChanged = YES;
            }
        }
        
        remoteStatus = status;
        
        if (waitingForCatchup) [self playIfCaughtUp];
        
        if ([controller.window shouldSyncPauses] && playPauseChanged) {
            if ([interface isPlaying] != [remoteStatus playing]) {
                [interface setPlaying:remoteStatus.playing];
                [self sendTimestampAndPausedInfo:nil]; // make the refresh look instant
            }
        }
    }
}

- (void)sendTimestampAndPausedInfo:(id)sender {
    SSInterfaceStatus * status = [[SSInterfaceStatus alloc] initWithInterface:interface];
    // TODO: only send updates when the status differs from previous local status
    
    NSDictionary * dict = [status dictionaryRepresentation];
    NSDictionary * object = @{@"type": @"status", @"status": dict};
    [controller.session sendRemoteObject:object];
    [controller.window handleLocalStatus:status];
    
    myStatus = status;
}

- (void)invalidate {
    [timer invalidate];
    timer = nil;
}

#pragma mark - Sync Methods -

- (void)takeTimeFromClient {
    if (!remoteStatus) {
        NSLog(@"Error: cannot take remote timestamp when it isn't available");
    }
    if (![interface isAvailable]) return;
    
    [interface setOffset:remoteStatus.offset];
    [self sendTimestampAndPausedInfo:self];
}

- (BOOL)isWaitingForCatchup {
    return waitingForCatchup;
}

- (void)waitForCatchup {
    if (waitingForCatchup) return;
    
    waitingForCatchup = YES;
    if ([interface isPlaying]) [interface setPlaying:NO];
}

- (void)cancelWaitForCatchup {
    waitingForCatchup = NO;
}

#pragma mark Private

- (void)playIfCaughtUp {
    if (![interface isAvailable]) {
        [controller.window handleCaughtUp];
        return;
    }
    
    if (remoteStatus.offset > myStatus.offset) {
        waitingForCatchup = NO;
        if (![interface isPlaying]) {
            [interface setPlaying:YES];
        }
        [controller.window handleCaughtUp];
    }
}

@end
