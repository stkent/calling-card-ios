//
//  SignInNavigationController.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/28/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

class SignInNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(displayNearbyViewController),
            name: "USER_SIGNED_IN",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(displaySignInViewController),
            name: "USER_SIGNED_OUT",
            object: nil)
    }
    
    func displayNearbyViewController(notification: NSNotification) {
        if let topViewController = viewControllers.last where topViewController is NearbyViewController {
            return
        }
        
        guard let signedInUser = notification.userInfo?["User"] as? User else {
            return
        }
        
        if let nearbyViewController = storyboard?.instantiateViewControllerWithIdentifier(NearbyViewController.storyboardId),
            currentUserRecipient = nearbyViewController as? CurrentUserRecipient {
                currentUserRecipient.setCurrentUser(signedInUser)
                setViewControllers([nearbyViewController], animated: true)
        }
    }
    
    func displaySignInViewController() {
        if let topViewController = viewControllers.last where topViewController is SignInViewController {
            return
        }
        
        if let signInViewController = storyboard?.instantiateViewControllerWithIdentifier(SignInViewController.storyboardId) {
            setViewControllers([signInViewController], animated: true)
        }
    }
    
}

extension SignInNavigationController: GIDSignInUIDelegate {}
