//
//  SSPreferencesController.h
//  ShowSync
//
//  Created by Alex Nichol on 9/1/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SSDefaultServer @"127.0.0.1"
#define SSDefaultPort 1337

@interface SSPreferencesController : NSObject {
    NSUserDefaults * defaults;
}

+ (SSPreferencesController *)sharedController;

@property (nonatomic, retain) NSString * connectHost;
@property (nonatomic, retain) NSNumber * connectPort;

@end
