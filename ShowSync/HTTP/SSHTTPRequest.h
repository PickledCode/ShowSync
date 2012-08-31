//
//  SSHTTPRequest.h
//  ShowSync
//
//  Created by Ryan Sullivan on 8/30/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSHTTPRequest : NSObject

+(NSDictionary*)postUrl:(NSString*)url withJsonData:(id)json;

@end
