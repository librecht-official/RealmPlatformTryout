//
//  UserRealmAPIClient.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

final class UserRealmAPIClient {
    let configuration: RealmAPIConfiguration
    let user: User
    
    init(configuration: RealmAPIConfiguration, user: User) {
        self.configuration = configuration
        self.user = user
    }
}
