//
//  SSPlexInterface.h
//  ShowSync
//
//  Created by Alex Nichol on 8/30/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSInterface.h"
#import "SSHTTPRequest.h"

@interface SSPlexInterface : NSObject <SSInterface> {
    NSString * plexHost;
    
    NSThread * bgThread;
    NSMutableDictionary * pending;
    
    BOOL serverActive;
    BOOL serverPlaying;
    NSTimeInterval serverOffset;
}

- (void)startBackground;
- (void)stopBackground;

@end
