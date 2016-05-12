//
//  AppDelegate.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/17/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        configureStatusAndNavigationBars(application)
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Initialize Nearby Messages manager
        GNSMessageManager.setDebugLoggingEnabled(true)
        
        return true
    }
    
    func application(
        application: UIApplication,
        openURL url: NSURL,
        options: [String: AnyObject]) -> Bool {
        
        return GIDSignIn.sharedInstance()
            .handleURL(
                url,
                sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    private func configureStatusAndNavigationBars(application: UIApplication) {
        // White status bar icons
        application.statusBarStyle = .LightContent
        
        // White navigation bar text
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // Colored status and navigation bar backgrounds
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = UIColor.deepRed()
    }

}
