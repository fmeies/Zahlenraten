//
//  ETRTracker.h
//  etracker-tracking-framework-ios
//
//  Copyright etracker GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * States for the \c -userConsent property.
 */
typedef NS_ENUM(NSInteger, ETRUserConsent) {
    ETRUserConsentUnknown,      ///< user hasn't decided yet
    ETRUserConsentDenied,       ///< user has denied tracking
    ETRUserConsentGranted,      ///< user has agreed
    ETRUserConsentNotRequired   ///< consent free tracking
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
 * Number of seconds between server updates (defaults to 10 seconds).
 */
#define ETRDefaultTimeInterval 10

@class ETROrder;

/**
 * This class provides the API to etracker's tracking service.
 *
 * You MUST call -startTrackerWithAccountKey:timeInterval: in you application delegate
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
@property (assign) ETRUserConsent userConsentTracking;

/**
 * Sets or returns whether user consent to tracking has been given. Without user consent,
 * tracking is automatically disabled. The property value is persistently stored in the standard
 * user defaults under the key "com.etracker.userConsent". Deprecated, use
 * userConsentTracking instead.
 */
@property (assign) ETRUserConsent userConsent;

/**
 * Sets or returns whether user consent to notifications has been given. Without user consent,
 * notifications are not allowed. The property value is persistently stored in the standard
 * user defaults under the key "com.etracker.userConsentNotifications".
 */
@property (assign) ETRUserConsent userConsentNotifications;

/**
 * Sets or returns the currently stored notification token. The property value is persistently
 * stored in the standard user defaults under the key "com.etracker.notificationToken".
 */
@property (copy) NSString *notificationToken;

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
 * Tracks a "screen view" event. The \c screenName must be a non-empty string.
 * The \c areas parameter is optional and may be replaced with nil.
 * The operation is a no-op if the \c screenName is invalid or tracking has
 * been temporarily or permanently disabled.
 *
 * The \c ETRTrackingViewController will automatically generate this event
 * on \c -viewDidAppear: and uses the \c screenName property which defaults
 * to the controllers's class name.
 */
- (void)trackScreenView:(NSString *)screenName areas:(NSString *)areas;

/**
 * Tracks the end of the screen view.
 * This is important for the calculation of the length of stay per screen view, especially for the last screen view.
 */
- (void)trackScreenViewEnd;

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
 * Tracks a custom event. The \c object,  \c category and the \c action must be
 * non-empty strings. The value is optional and may be replaced with nil, but if
 * set it must be an integer. The screenName and areas parameter is optional and
 * may be replaced with nil. The operation is a no-op if the \object, \c
 * category or the \c action are invalid or tracking has been temporarily or
 * permanently disabled.
 */
- (void)trackUserDefined:(NSString *)category action:(NSString *)action
                  object:(NSString *)object value:(NSString *)value
                  screenName:(NSString *)screenName areas:(NSString *)areas;

/**
 * Tracks an order as defined by the given \c order object, which must be non-nil.
 * The operation is a no-op if the \c order is nil or contains values which cannot
 * be converted into a JSON document or if tracking has been temporarily or
 * permanently disabled.
 */
- (void)trackOrder:(ETROrder *)order;

/**
 * Tracks a notification opt-in opens event.
 */
- (void)trackNotificationOptInOpens;

/**
 * Tracks a notification opt-in allow event.
 */
- (void)trackNotificationOptInAllow;

/**
 * Tracks a notification opt-in deny event.
 */
- (void)trackNotificationOptInDeny;

/**
 * Sends the list of notification topics, the user is interested in, to the server. \c topics is a comma separated list of topics.
 * The \c topics must be a non-empty string.
 */
- (void)trackNotificationTopics:(NSString *)topics;

/**
 * Tracks a shown notification event. The \c messageId is the id passed over in the notification.
 * The \c title must be a non-empty string.
 */
- (void)trackNotificationShown:(NSString *)messageId title:(NSString *)title;

/**
 * Tracks a clicked notification event. The \c messageId is the id passed over in the notification.
 * The \c title must be a non-empty string.
 */
- (void)trackNotificationClicked:(NSString *)messageId title:(NSString *)title;

/**
 * Sends a notification token to the server. If \c token is nil, the current token is sent.
 */
- (void)sendNotificationToken:(NSString *)token;

/**
 * Revokes the current notification token.
 */
- (void)revokeNotificationToken;

@end
