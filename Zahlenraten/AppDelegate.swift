//
//  AppDelegate.swift
//  Zahlenraten
//
//  Created by Frank Meies on 24.01.15.
//  Copyright (c) 2015 Frank Meies. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		prepareDefaultSettings()
		prepareTracking()
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
		ETRTracker.shared().sendPendingEventsNow()
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
		prepareTracking()
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		endTracking()
	}
	
	fileprivate func prepareDefaultSettings() {
		let userDefaults = UserDefaults.standard
		let defaults = [ "TrackingPreference" : true ]
		userDefaults.register(defaults: defaults)
		userDefaults.synchronize()
	}
	
	fileprivate func prepareTracking(){
		let userDefaults = UserDefaults.standard
		let trackingAllowed = userDefaults.bool(forKey: "TrackingPreference")
		if trackingAllowed {
			let tracker = ETRTracker.shared()!
			if tracker.userConsent != ETRUserConsent.granted {
				// actually we would have to ask the user:
				tracker.userConsent = ETRUserConsent.granted
			}
			
//			setenv("ETRSERVERURL","http://tracking.etbox.qa.hhoffice.de.etracker.com",1);
//			tracker.start(withAccountKey: "2SVUSV", sharedSecret: "", timeInterval: 10)
			tracker.start(withAccountKey: "wsxT8K", sharedSecret: "", timeInterval: 10)
			tracker.debug = true
			tracker.trackScreenView("Zahlenraten Main View", areas: "Zahlenraten Main Area")
			tracker.sendPendingEventsNow()
		}
	}
	
	fileprivate func endTracking(){
		ETRTracker.shared().stop()
	}
}

