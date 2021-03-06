//
//  SSSyncController.h
//  ShowSync
//
//  Created by Alex Nichol on 8/29/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSInterfaceFactory.h"
#import "SSInterfaceStatus.h"

@class SSController;

@interface SSSyncController : NSObject <SSInterfaceDelegate> {
    NSUInteger sentCount;
    
    __weak SSController * controller;
    BOOL waitingForCatchup;
    
    SSInterface * interface;
    
    SSInterfaceStatus * myStatus;
    SSInterfaceStatus * remoteStatus;
}

- (id)initWithController:(SSController *)aController;
- (void)handleObject:(NSDictionary *)object;

- (void)invalidate;

- (void)takeTimeFromClient;
- (BOOL)isWaitingForCatchup;
- (void)waitForCatchup;
- (void)cancelWaitForCatchup;

@end
