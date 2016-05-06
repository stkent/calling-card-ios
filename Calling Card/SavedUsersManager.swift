//
//  SavedUsersManager.swift
//  Calling Card
//
//  Created by Stuart Kent on 5/4/16.
//  Copyright © 2016 Stuart Kent. All rights reserved.
//

import Foundation

struct SavedUsersManager {

    private static let SAVED_USERS_KEY = "SavedUsersKey"

    private let defaults: NSUserDefaults

    init(defaults: NSUserDefaults = .standardUserDefaults()) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        self.defaults = defaults
    }

    func getSavedUsers() -> [User] {
        guard let restoredData = defaults.objectForKey(SavedUsersManager.SAVED_USERS_KEY) as? [NSData] else {
            return [User]()
        }
        
        return restoredData.flatMap { User(nsData: $0) }
    }

    func saveUser(user: User) {
        let existingSavedUsers = getSavedUsers()

        if !existingSavedUsers.contains(user) {
            let updatedSavedUsers = existingSavedUsers + [user]
            let dataToSave = updatedSavedUsers.flatMap { $0.toNSData() }
            defaults.setObject(dataToSave, forKey: SavedUsersManager.SAVED_USERS_KEY)
        }
    }
    
    func deleteUser(user: User) {
        let existingSavedUsers = getSavedUsers()
        
        if existingSavedUsers.contains(user) {
            let updatedSavedUsers = existingSavedUsers.filter { $0 != user }
            defaults.setObject(updatedSavedUsers, forKey: SavedUsersManager.SAVED_USERS_KEY)
        }
    }

}
