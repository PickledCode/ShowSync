/*
 * QuickTime Player.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class QuickTimePlayerApplication, QuickTimePlayerDocument, QuickTimePlayerWindow, QuickTimePlayerVideoRecordingDevice, QuickTimePlayerAudioRecordingDevice, QuickTimePlayerAudioCompressionPreset, QuickTimePlayerMovieCompressionPreset, QuickTimePlayerScreenCompressionPreset;

enum QuickTimePlayerSaveOptions {
	QuickTimePlayerSaveOptionsYes = 'yes ' /* Save the file. */,
	QuickTimePlayerSaveOptionsNo = 'no  ' /* Do not save the file. */,
	QuickTimePlayerSaveOptionsAsk = 'ask ' /* Ask the user whether or not to save the file. */
};
typedef enum QuickTimePlayerSaveOptions QuickTimePlayerSaveOptions;

enum QuickTimePlayerPrintingErrorHandling {
	QuickTimePlayerPrintingErrorHandlingStandard = 'lwst' /* Standard PostScript error handling */,
	QuickTimePlayerPrintingErrorHandlingDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum QuickTimePlayerPrintingErrorHandling QuickTimePlayerPrintingErrorHandling;



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface QuickTimePlayerApplication : SBApplication

- (SBElementArray *) documents;
- (SBElementArray *) windows;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the active application?
@property (copy, readonly) NSString *version;  // The version number of the application.

- (id) open:(id)x;  // Open a document.
- (void) print:(id)x withProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) quitSaving:(QuickTimePlayerSaveOptions)saving;  // Quit the application.
- (BOOL) exists:(id)x;  // Verify that an object exists.
- (void) openURL:(NSString *)x;  // Open a URL.
- (QuickTimePlayerDocument *) newMovieRecording;  // Create a new movie recording document.
- (QuickTimePlayerDocument *) newAudioRecording;  // Create a new audio recording document.
- (QuickTimePlayerDocument *) newScreenRecording;  // Create a new screen recording document.

@end

// A document.
@interface QuickTimePlayerDocument : SBObject

@property (copy, readonly) NSString *name;  // Its name.
@property (readonly) BOOL modified;  // Has it been modified since the last save?
@property (copy, readonly) NSURL *file;  // Its location on disk, if it has one.

- (void) closeSaving:(QuickTimePlayerSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.
- (void) play;  // Play the movie.
- (void) start;  // Start the movie recording.
- (void) pause;  // Pause the recording.
- (void) resume;  // Resume the recording.
- (void) stop;  // Stop the movie or recording.
- (void) stepBackwardBy:(NSInteger)by;  // Step the movie backward the specified number of steps (default is 1).
- (void) stepForwardBy:(NSInteger)by;  // Step the movie forward the specified number of steps (default is 1).
- (void) trimFrom:(double)from to:(double)to;  // Trim the movie.
- (void) present;  // Present the document full screen.
- (void) exportIn:(NSURL *)in_ usingSettingsPreset:(NSString *)usingSettingsPreset;  // Export a movie to another file

@end

// A window.
@interface QuickTimePlayerWindow : SBObject

@property (copy, readonly) NSString *name;  // The title of the window.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Does the window have a close button?
@property (readonly) BOOL miniaturizable;  // Does the window have a minimize button?
@property BOOL miniaturized;  // Is the window minimized right now?
@property (readonly) BOOL resizable;  // Can the window be resized?
@property BOOL visible;  // Is the window visible right now?
@property (readonly) BOOL zoomable;  // Does the window have a zoom button?
@property BOOL zoomed;  // Is the window zoomed right now?
@property (copy, readonly) QuickTimePlayerDocument *document;  // The document whose contents are displayed in the window.

- (void) closeSaving:(QuickTimePlayerSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end



/*
 * Internet Suite
 */

@interface QuickTimePlayerApplication (InternetSuite)

@end



/*
 * QuickTime Player Suite
 */

// A video recording device
@interface QuickTimePlayerVideoRecordingDevice : SBObject

@property (copy, readonly) NSString *name;  // The name of the device.
- (NSString *) id;  // The unique identifier of the device.

- (void) closeSaving:(QuickTimePlayerSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// An audio recording device
@interface QuickTimePlayerAudioRecordingDevice : SBObject

@property (copy, readonly) NSString *name;  // The name of the device.
- (NSString *) id;  // The unique identifier of the device.

- (void) closeSaving:(QuickTimePlayerSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// An audio recording compression preset
@interface QuickTimePlayerAudioCompressionPreset : SBObject

@property (copy, readonly) NSString *name;  // The name of the preset.
- (NSString *) id;  // The unique identifier of the preset.

- (void) closeSaving:(QuickTimePlayerSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// A movie recording compression preset
@interface QuickTimePlayerMovieCompressionPreset : SBObject

@property (copy, readonly) NSString *name;  // The name of the preset.
- (NSString *) id;  // The unique identifier of the preset.

- (void) closeSaving:(QuickTimePlayerSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// A screen recording compression preset
@interface QuickTimePlayerScreenCompressionPreset : SBObject

@property (copy, readonly) NSString *name;  // The name of the preset.
- (NSString *) id;  // The unique identifier of the preset.

- (void) closeSaving:(QuickTimePlayerSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(id)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

@interface QuickTimePlayerApplication (QuickTimePlayerSuite)

- (SBElementArray *) videoRecordingDevices;
- (SBElementArray *) audioRecordingDevices;
- (SBElementArray *) audioCompressionPresets;
- (SBElementArray *) movieCompressionPresets;
- (SBElementArray *) screenCompressionPresets;

@end

@interface QuickTimePlayerDocument (QuickTimePlayerSuite)

@property double audioVolume;  // The volume of the movie from 0 to 1, where 1 is 100%.
@property double currentTime;  // The current time of the movie in seconds.
@property (readonly) NSInteger dataRate;  // The data rate of the movie in bytes per second.
@property (readonly) NSInteger dataSize;  // The data size of the movie in bytes.
@property (readonly) double duration;  // The duration of the movie in seconds.
@property BOOL looping;  // Is the movie playing in a loop?
@property BOOL muted;  // Is the movie muted?
@property (readonly) NSPoint naturalDimensions;  // The natural dimensions of the movie.
@property (readonly) BOOL playing;  // Is the movie playing?
@property double rate;  // The current rate of the movie.
@property BOOL presenting;  // Is the movie presented in full screen?
@property (copy) QuickTimePlayerAudioRecordingDevice *currentMicrophone;  // The currently previewing audio device.
@property (copy) QuickTimePlayerVideoRecordingDevice *currentCamera;  // The currently previewing video device.
@property (copy) QuickTimePlayerAudioCompressionPreset *currentAudioCompression;  // The current audio compression preset.
@property (copy) QuickTimePlayerMovieCompressionPreset *currentMovieCompression;  // The current movie compression preset.
@property (copy) QuickTimePlayerScreenCompressionPreset *currentScreenCompression;  // The current screen compression preset.

@end

