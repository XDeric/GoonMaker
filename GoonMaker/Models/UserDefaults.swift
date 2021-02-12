//
//  UserDefaults.swift
//  GoonMaker
//
//  Created by Gregory Keeley on 2/12/21.
//

import Foundation


struct UserPreferenceKey {
    static let userName = "User Name"
}

class UserPreference {
    private init() {}
    private let standard = UserDefaults.standard
    static let shared = UserPreference()
    
    //TODO: Write functions for saving, and updating a user name from the settings ViewController. I wrote out some quick ones, hopefully they work 
    func setUserName(with name: String) {
        standard.setValue(name, forKey: UserPreferenceKey.userName)
    }
    func getUserName() -> String?  {
        guard let name = standard.object(forKey: UserPreferenceKey.userName) as? String else {
            return nil
        }
        return name
    }
}
