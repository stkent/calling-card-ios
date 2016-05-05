//
//  User.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/26/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import Foundation

final class User: NSObject {
    
    let id: String
    let name: String
    let emailAddress: String
    let photoUrlString: String
    
    private init(
        id: String,
        name: String,
        emailAddress: String,
        photoUrlString: String) {
        
            self.id = id
            self.name = name
            self.emailAddress = emailAddress
            self.photoUrlString = photoUrlString
    }
    
    convenience init(gidGoogleUser: GIDGoogleUser) {
        let gidProfileData = gidGoogleUser.profile
        
        self.init(
            id: gidGoogleUser.userID,
            name: gidProfileData.name,
            emailAddress: gidProfileData.email,
            photoUrlString: gidProfileData.imageURLWithDimension(300).absoluteString)
    }

}
