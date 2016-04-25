//
//  ViewController.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/17/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }

}

extension ViewController: GIDSignInDelegate {
    
    func signIn(
        signIn: GIDSignIn!,
        didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
        
            if (error == nil) {
                let userId = user.userID
                let gidProfileData = user.profile
                let fullName = gidProfileData.name
                let photoUrl = gidProfileData.imageURLWithDimension(100) // TODO: revisit this number!
                let emailAddress = gidProfileData.email
            } else {
                print("\(error.localizedDescription)")
            }
    }
    
    func signIn(
        signIn: GIDSignIn!,
        didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
        
        // TODO
    }
    
}

extension ViewController: GIDSignInUIDelegate {}
