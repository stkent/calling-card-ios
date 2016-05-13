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
        configureGoogleSignIn()
        configureNearbyMessagesManager()
        
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
    
    private func configureGoogleSignIn() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
    }
    
    private func configureNearbyMessagesManager() {
        GNSMessageManager.setDebugLoggingEnabled(true)
    }

}

extension AppDelegate: GIDSignInDelegate {
    
    func signIn(
        signIn: GIDSignIn!,
        didSignInForUser gidGoogleUser: GIDGoogleUser!,
        withError error: NSError!) {
        
            if (error == nil) {
                NSNotificationCenter.defaultCenter().postNotificationName(
                    "USER_SIGNED_IN",
                    object: nil,
                    userInfo: ["User": User(gidGoogleUser: gidGoogleUser)])
            } else {
                print("\(error.localizedDescription)")
                
                NSNotificationCenter.defaultCenter().postNotificationName(
                    "USER_SIGNED_OUT",
                    object: nil)
            }
    }
    
    func signIn(
        signIn: GIDSignIn!,
        didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
        
            NSNotificationCenter.defaultCenter().postNotificationName(
                "USER_SIGNED_OUT",
                object: nil)
    }
    
}
