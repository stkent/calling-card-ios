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
        self.defaults = defaults
    }

    func getSavedUsers() -> [User] {
        return defaults.objectForKey(SavedUsersManager.SAVED_USERS_KEY) as? [User] ?? [User]()
    }

    func saveUser(user: User) {
        let existingSavedUsers = getSavedUsers()

        if !existingSavedUsers.contains(user) {
            let updatedSavedUsers = existingSavedUsers + [user]
            defaults.setObject(updatedSavedUsers, forKey: SavedUsersManager.SAVED_USERS_KEY)
        }
    }

}
