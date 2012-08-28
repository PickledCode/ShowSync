//
//  SSController.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSMainWindow.h"
#import "KBPSession.h"

#define SSDefaultServer @"127.0.0.1"
#define SSDefaultPort 1337

@interface SSController : NSObject <KBPSessionDelegate> {
    SSMainWindow * window;
    KBPSession * session;
}

@property (readonly) SSMainWindow * window;

- (id)initWithWindow:(SSMainWindow *)aWindow;

- (void)registerTag:(NSString *)tag;
- (void)unregister;
- (void)viewClosed;

@end
