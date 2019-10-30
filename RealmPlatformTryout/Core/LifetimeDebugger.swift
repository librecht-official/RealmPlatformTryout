//
//  LifetimeDebugger.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

#if DEBUG
final class LifetimeDebugger {
    let name: String
    
    init(_ name: String) {
        self.name = name
        print("\(self) \(name) init")
    }
    
    deinit {
        print("\(self) \(name) deinit")
    }
}
#endif
