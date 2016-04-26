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
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        }
    }
    
    private func displayNearbyViewController(currentUser: User) {
        if let topViewController = viewControllers.last where topViewController is NearbyViewController {
            return
        }
        
        if let nearbyViewController = storyboard?.instantiateViewControllerWithIdentifier(NearbyViewController.storyboardId),
            currentUserRecipient = nearbyViewController as? CurrentUserRecipient {
                currentUserRecipient.setCurrentUser(currentUser)
                setViewControllers([nearbyViewController], animated: true)
        }
    }
    
    private func displaySignInViewController() {
        if let topViewController = viewControllers.last where topViewController is SignInViewController {
            return
        }
        
        if let signInViewController = storyboard?.instantiateViewControllerWithIdentifier(SignInViewController.storyboardId) {
            setViewControllers([signInViewController], animated: true)
        }
    }
    
}

extension SignInNavigationController: GIDSignInDelegate {
    
    func signIn(
        signIn: GIDSignIn!,
        didSignInForUser gidGoogleUser: GIDGoogleUser!,
        withError error: NSError!) {
        
            if (error == nil) {
                print("User signed in.")
                displayNearbyViewController(User(gidGoogleUser: gidGoogleUser))
            } else {
                print(error.localizedDescription)
            }
    }
    
    func signIn(
        signIn: GIDSignIn!,
        didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
        
            if (error == nil) {
                print("User signed out.")
                displaySignInViewController()
            } else {
                print(error.localizedDescription)
            }
    }
    
}

extension SignInNavigationController: GIDSignInUIDelegate {}
