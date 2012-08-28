//
//  SSInterface.h
//  ShowSync
//
//  Created by Alex Nichol on 8/28/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSInterface <NSObject>

- (BOOL)isAvailable;

- (NSTimeInterval)offset;
- (void)setOffset:(NSTimeInterval)offset;
- (BOOL)isPlaying;
- (void)setPlaying:(BOOL)playing;

@end
