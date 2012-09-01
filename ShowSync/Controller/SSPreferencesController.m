//
//  SSPreferencesController.m
//  ShowSync
//
//  Created by Alex Nichol on 9/1/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSPreferencesController.h"

#define SS_DYNAMIC_PROP(w,x,y,z) - (y *)w {\
    return [defaults objectForKey:z];\
}\
- (void)x:(y *)obj {\
    [defaults setObject:obj forKey:z];\
    [defaults synchronize];\
}

@implementation SSPreferencesController

SS_DYNAMIC_PROP(connectHost, setConnectHost, NSString, @"host")
SS_DYNAMIC_PROP(connectPort, setConnectPort, NSNumber, @"port")

+ (SSPreferencesController *)sharedController {
    static SSPreferencesController * controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[SSPreferencesController alloc] init];
    });
    return controller;
}

- (id)init {
    if ((self = [super init])) {
        defaults = [NSUserDefaults standardUserDefaults];
        if (![self connectHost]) [self setConnectHost:SSDefaultServer];
        if (![self connectPort]) [self setConnectPort:@SSDefaultPort];
    }
    return self;
}

@end
