//
//  ETRTracker.h
//  etracker-tracking-framework-ios
//
//  Copyright 2011, 2014 etracker GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * States for the \c -userConsent property.
 */
typedef NS_ENUM(NSInteger, ETRUserConsent) {
    ETRUserConsentUnknown,  ///< user hasn't decided yet
    ETRUserConsentDenied,   ///< user has denied tracking
    ETRUserConsentGranted   ///< user has agreed
};


/**
 * States for the \c -trackApplicationLifecycle: event.
 */
typedef NS_ENUM(NSInteger, ETRApplicationLifecycle) {
    ETRApplicationLifecycleBegin,
    ETRApplicationLifecyclePause,
    ETRApplicationLifecycleResume,
    ETRApplicationLifecycleEnd,
    ETRApplicationLifecycleStartActivity,
    ETRApplicationLifecycleStopActivity
};

/**
 * Simple Location class
 */
@interface Location : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

- (id)initWithLatitude:(double)latitude longitude:(double)longitude;
@end

/**
 * Number of seconds between server updates (defaults to once per minute).
 */
#define ETRDefaultTimeInterval 60

/**
 * This class provides the API to etracker's tracking service.
 *
 * You MUST call -startTrackerWithAccountKey:sharedSecret:timeInterval: in you application delegate
 * to setup the tracking service. You should call -stopTracker if your application gets terminated 
 * to tear down the service.
 * 
 * A background process will periodicaly post all pending events to the tracking service until
 * -stopTracker is called. Up to 10000 events are stored. Sending is attempted 12 times. Then
 * the oldest are discarded.
 *
 * The class is thread-safe unless otherwise stated.
 */
@interface ETRTracker : NSObject

/**
 * Returns the shared instance used to communicate with the etracker tracking service.
 */
+ (ETRTracker *)sharedTracker;

/**
 * Initializes tracking. An account key to identify the etracker account must be provided.
 * Furthermore, a shared secred can be provided to sign all requests so that the etracker server
 * will be able to detect tampering with requests by third parties. This is optional and can be nil.
 * The third parameter is the time in seconds the service will wait before sending all pending events.
 */
- (void)startTrackerWithAccountKey:(NSString *)accountKey
                      sharedSecret:(NSString *)sharedSecret
                      timeInterval:(NSTimeInterval)timeInterval;

/**
 * Stops the tracker and frees all allocated resources.
 */
- (void)stopTracker;

/**
 * Sends all pending events to the server now.
 * This is a non blocking call.
 */
- (void)sendPendingEventsNow;

/**
 * Sets or returns whether user consent to tracking has been given. Without user consent,
 * tracking is automatically disabled. The property value is persistently stored in the standard
 * user defaults under the key "com.etracker.userConsent".
 */
@property (assign) ETRUserConsent userConsent;

/**
 * Sets or returns whether tracking is enabled or not. Defaults to YES.
 * Temporarily disabling the tracking will not remove pending events.
 */
@property (assign) BOOL enabled;

/**
 * Sets or returns whether debug logging is enabled or not. Defaults to NO.
 */
@property (assign) BOOL debug;

/**
 * Sets or returns the name of the folder used to store the pending events.
 * By default, this is "~/Library/Caches/com.etracker".
 */
@property (copy) NSString *pendingEventsFolderPath;

/**
 * The location that is used for geo location tracking.
 * Update the location that is used for tracking manually if you don't want to use the automatic location tracking
 */
@property (copy) Location *currentLocation;

/**
 * Tracks a custom event. The \c object,  \c category and the \c action must be
 * non-empty strings. The value is optional and may be replaced with nil, but if
 * set it must be an integer. The operation is a no-op if the \object, \c
 * category or the \c action are invalid or tracking has been temporarily or
 * permanently disabled.
 */
- (void)trackUserDefined:(NSString *)category action:(NSString *)action
                         object:(NSString *)object value:(NSString *)value;

/**
 * Tracks a "screen view" event. The \c screenName must be a non-empty string.
 * The operation is a no-op if the \c screenName is invalid or tracking has
 * been temporarily or permanently disabled.
 *
 * The \c ETRTrackingViewController will automatically generate this event
 * on \c -viewDidAppear: and uses the \c screenName property which defaults
 * to the controllers's class name.
 */
- (void)trackScreenView:(NSString *)screenName;

/**
 * Tracks the view starts durations counter
 */
- (void)trackViewLoaded:(NSString *)viewName;


/**
 * Tracks the view stops duration counter
 */
- (void)trackViewUnloaded:(NSString *)viewName;

/**
 * Tracks an order as defined by the given \c order object, which must be non-nil.
 * The operation is a no-op if the \c order is nil or contains values which cannot
 * be converted into a JSON document or if tracking has been temporarily or
 * permanently disabled.
 */
- (void)trackOrder:(NSDictionary *)order;

/**
 * Sets or returns whether the automatic location tracking is enabled or not. Defaults to NO.
 * It uses the significant-change location service, that provides accuracy that’s
 * good enough and represents a power-saving alternative to the standard location service. If the user has disabled the
 * location service for this app, enabling this will ask the user again for re-enabling it.
 * If you want to prevent that, test for the location service status before calling this method.
 * Make sure to link with CoreLocation.framework in order to use this.
 */
@property (nonatomic, assign) BOOL automaticLocationTrackingEnabled;

@end
