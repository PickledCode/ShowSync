//
//  SSHTTPRequest.m
//  ShowSync
//
//  Created by Ryan Sullivan on 8/30/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "SSHTTPRequest.h"

@implementation SSHTTPRequest

+(NSDictionary*)postUrl:(NSString*)url withJsonData:(id)json {
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:data];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];

//    NSLog(@"Req: %@", json);
//    NSLog(@"Resp: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    if (error) {
        NSLog(@"Request error: %@", error);
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
}

@end
