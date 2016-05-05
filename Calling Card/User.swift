//
//  User.swift
//  Calling Card
//
//  Created by Stuart Kent on 4/26/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import Foundation

final class User: NSObject {
    
    private static let KEY_ID = "id"
    private static let KEY_NAME = "name"
    private static let KEY_EMAIL_ADDRESS = "emailAddress"
    private static let KEY_PHOTO_URL_STRING = "photoUrlString"
    
    let id: String
    let name: String
    let emailAddress: String
    let photoUrlString: String?
    
    private init(
        id: String,
        name: String,
        emailAddress: String,
        photoUrlString: String?) {
        
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
    
    convenience init?(nsData: NSData) {
        guard let
            deserializedObject = try? NSJSONSerialization.JSONObjectWithData(nsData, options: []),
            dictRepresentation = deserializedObject as? [String: String]
            else {
                return nil
        }
        
        guard let
            id = dictRepresentation[User.KEY_ID],
            name = dictRepresentation[User.KEY_NAME],
            emailAddress = dictRepresentation[User.KEY_EMAIL_ADDRESS]
            else {
                return nil
        }
        
        self.init(
            id: id,
            name: name,
            emailAddress: emailAddress,
            photoUrlString: dictRepresentation[User.KEY_PHOTO_URL_STRING])
    }
    
    func toNSData() -> NSData? {
        var dictRepresentation: [String: String] = [
            User.KEY_ID: id,
            User.KEY_NAME: name,
            User.KEY_EMAIL_ADDRESS: emailAddress
        ]
        
        if let photoUrlString = photoUrlString {
            dictRepresentation[User.KEY_PHOTO_URL_STRING] = photoUrlString
        }
        
        return try? NSJSONSerialization.dataWithJSONObject(dictRepresentation, options: [])
    }

}
