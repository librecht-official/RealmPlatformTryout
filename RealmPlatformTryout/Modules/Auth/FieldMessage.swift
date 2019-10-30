//
//  FieldMessage.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

enum FieldMessage {
    case info(String)
    case error(String)
    
    var text: String {
        switch self {
        case let .info(text), let .error(text):
            return text
        }
    }
}
