//
//  SSInterfaceStatus.h
//  ShowSync
//
//  Created by Alex Nichol on 8/29/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSInterface.h"

@interface SSInterfaceStatus : NSObject {
    BOOL available;
    BOOL playing;
    NSTimeInterval offset;
}

@property (readonly) BOOL available;
@property (readonly) BOOL playing;
@property (readonly) NSTimeInterval offset;

- (id)initUnavailable;
- (id)initWithPlaying:(BOOL)playing offset:(NSTimeInterval)offset;
- (id)initWithInterface:(SSInterface *)interface;

- (BOOL)isEqualToStatus:(SSInterfaceStatus *)status;

- (NSDictionary *)dictionaryRepresentation;
+ (SSInterfaceStatus *)interfaceStatusWithDictionaryRepresentation:(NSDictionary *)dictionary;

@end
