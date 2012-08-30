//
//  SSSyncController.m
//  ShowSync
//
//  Created by Alex Nichol on 8/29/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSSyncController.h"
#import "SSController.h"

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
    }
}

- (void)sendTimestampAndPausedInfo:(id)sender {
    SSInterfaceStatus * status = [[SSInterfaceStatus alloc] initWithInterface:interface];
    // TODO: only send updates when the status differs from previous local status
    
    NSDictionary * dict = [status dictionaryRepresentation];
    NSDictionary * object = @{@"type": @"status", @"status": dict};
    [controller.session sendRemoteObject:object];
    [controller.window handleLocalStatus:status];
}

- (void)invalidate {
    [timer invalidate];
    timer = nil;
}

@end
