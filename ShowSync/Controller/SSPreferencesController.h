//
//  SSPreferencesController.h
//  ShowSync
//
//  Created by Alex Nichol on 9/1/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSPreferencesController : NSObject {
    NSUserDefaults * defaults;
}

+ (SSPreferencesController *)sharedController;

@property (nonatomic, retain) NSString * connectHost;
@property (nonatomic, retain) NSNumber * connectPort;

@end
