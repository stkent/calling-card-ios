//
//  AppDelegate.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/17/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
                
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

}
