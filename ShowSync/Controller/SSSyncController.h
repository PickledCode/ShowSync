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

@interface SSSyncController : NSObject {
    __weak SSController * controller;
    BOOL waitingForCatchup;
    
    NSTimer * timer;
    id<SSInterface> interface;
}

- (id)initWithController:(SSController *)aController;
- (void)handleObject:(NSDictionary *)object;

- (void)sendTimestampAndPausedInfo:(id)sender;
- (void)invalidate;

@end
