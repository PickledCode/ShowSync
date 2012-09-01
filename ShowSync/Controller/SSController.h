//
//  SSController.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSMainWindow.h"
#import "SSSyncController.h"
#import "SSPreferencesController.h"

#define SSDefaultServer @"127.0.0.1"
#define SSDefaultPort 1337

@interface SSController : NSObject <KBPSessionDelegate> {
    SSMainWindow * window;
    KBPSession * session;
    
    SSSyncController * syncController;
}

@property (readonly) SSMainWindow * window;
@property (readonly) SSSyncController * syncController;
@property (readonly) KBPSession * session;

- (id)initWithWindow:(SSMainWindow *)aWindow;

- (BOOL)isRegistered;
- (void)registerTag:(NSString *)tag;
- (void)unregister;
- (void)viewClosed;

@end
