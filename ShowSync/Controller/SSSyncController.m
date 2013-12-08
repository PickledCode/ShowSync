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
        sentCount = 0;
        
        controller = aController;
        
        // create the interface based on user application drop-down
        NSString * interfaceName = aController.window.applicationName;
        interface = [SSInterfaceFactory interfaceWithName:interfaceName];
        interface.delegate = self;
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
            BOOL remoteWaiting = [[object objectForKey:@"waiting"] boolValue];
            if ([interface isPlaying] != [remoteStatus playing] && !remoteWaiting && !waitingForCatchup) {
                [interface setPlaying:remoteStatus.playing];
                [self interfaceStatusChanged:nil]; // make the refresh look instant
            }
        }
    }
}

#pragma mark - Sending Updates -

- (void)interfaceStatusChanged:(id)sender {
    SSInterfaceStatus * status = [[SSInterfaceStatus alloc] initWithInterface:interface];
    sentCount++;
    if ([status isEqualToStatus:myStatus]) return;
    
    NSDictionary * dict = [status dictionaryRepresentation];
    NSDictionary * object = @{@"type": @"status",
                              @"status": dict,
                              @"waiting": [NSNumber numberWithBool:waitingForCatchup]};
    [controller.session sendRemoteObject:object];
    [controller.window handleLocalStatus:status];
    
    myStatus = status;
}


- (void)invalidate {
    [interface invalidate];
}

#pragma mark - Sync Methods -

- (void)takeTimeFromClient {
    if (!remoteStatus) {
        NSLog(@"Error: cannot take remote timestamp when it isn't available");
    }
    if (![interface isAvailable]) return;
    
    [interface setOffset:remoteStatus.offset];
    [self interfaceStatusChanged:nil];
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
    
    if (remoteStatus.offset >= myStatus.offset) {
        waitingForCatchup = NO;
        if (![interface isPlaying]) {
            [interface setPlaying:YES];
        }
        [controller.window handleCaughtUp];
    }
}

@end
