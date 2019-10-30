//
//  APIError.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 27/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

public enum APIError: Error {
    case openRealm(Error)
    case writeTransactionFailed(Error)
    case unknown
}
