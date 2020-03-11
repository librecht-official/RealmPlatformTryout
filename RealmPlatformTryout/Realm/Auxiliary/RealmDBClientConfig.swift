//
//  RealmDBClientConfig.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 30/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation


public struct RealmDBClientConfig {
    let instanceAddress: String
    let authURL: URL
    let publicRealmURL: URL
    let userRealmURL: URL
    
    public init(instanceAddress: String) {
        self.instanceAddress = instanceAddress
        self.authURL = URL(string: "https://\(instanceAddress)")!
        self.publicRealmURL = URL(string: "realms://\(instanceAddress)/public")!
        self.userRealmURL = URL(string: "realms://\(instanceAddress)/~/default")!
    }
}
