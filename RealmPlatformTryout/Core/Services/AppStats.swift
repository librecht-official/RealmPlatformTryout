//
//  AppStats.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 09/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation

enum AppPersistence {
    
    // MARK: FirstLaunch
    
    
    // MARK: User
    
    static func isUserGuest() -> Bool {
        return UserDefaults.standard.bool(forKey: "PublicRealmAPIClient.IsGuestUser")
    }
    static func setUserIsGuest(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: "PublicRealmAPIClient.IsGuestUser")
    }
}
