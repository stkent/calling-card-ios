//
//  User.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/26/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import Foundation

final class User: NSObject {
    
    private static let ID_KEY = "ID"
    private static let GID_PROFILE_DATA_KEY = "GID_PROFILE_DATA"
    
    let id: String
    
    private let gidProfileData: GIDProfileData
    
    private init(id: String, gidProfileData: GIDProfileData) {
        self.id = id
        self.gidProfileData = gidProfileData
    }
    
    convenience init(gidGoogleUser: GIDGoogleUser) {
        self.init(id: gidGoogleUser.userID, gidProfileData: gidGoogleUser.profile)
    }
    
    var name: String {
        return gidProfileData.name
    }
    
    var emailAddress: String {
        return gidProfileData.email
    }

    func getPhotoURL(dimension: Int) -> NSURL {
        return gidProfileData.imageURLWithDimension(UInt(dimension))
    }

}
