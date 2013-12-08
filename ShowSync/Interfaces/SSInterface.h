//
//  SSInterface.h
//  ShowSync
//
//  Created by Alex Nichol on 12/8/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSInterfaceDelegate

- (void)interfaceStatusChanged:(id)sender;

@end

// recommended update intervals
#define kSSInterfacePollingInterval 0.25
#define kSSInterfaceEventInterval 0.5

/**
 * Represents an abstract interface with a media player.
 */
@interface SSInterface : NSObject {
    NSTimer * updateTimer;
}

@property (nonatomic, weak) id<SSInterfaceDelegate> delegate;

/**
 * Call this method to call -interfaceStatusChanged: 
 * on the delegate (will forward to main thread if needed).
 */
- (void)triggerStatusChanged;

/**
 * Return the user-readable name for the interface
 */
+ (NSString *)interfaceName;

/**
 * Return the number of seconds between automatic delegate
 * status change triggers. The default is kSSInterfacePollingInterval.
 * Return 0 to take complete control of sending updates.
 * @discussion By default, SSInterface will automatically
 * send status updates as needed at the given interval. This
 * is necessary for legacy interface support.
 */
+ (NSTimeInterval)updateInterval;

/**
 * Report if the interface is currently available.
 */
- (BOOL)isAvailable;

/**
 * Return the current offset.
 */
- (NSTimeInterval)offset;

/**
 * Indicates that the user or remote has requested
 * for this interface to seek in the file.
 */
- (void)setOffset:(NSTimeInterval)offset;

/**
 * Return the playing status.
 */
- (BOOL)isPlaying;

/**
 * Indicates that the user or remoet has requested
 * for this interface to play or pause.
 */
- (void)setPlaying:(BOOL)playing;

/**
 * Called when the user closes a ShowSync window or terminates a session.
 * @discussion You must call [super invalidate] to stop the update timer.
 */
- (void)invalidate;

@end
