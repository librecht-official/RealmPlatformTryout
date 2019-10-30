//
//  Format.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 05/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation

enum Format {
    
}

extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
}
