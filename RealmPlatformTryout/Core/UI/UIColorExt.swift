//
//  UIColorExt.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 12/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


extension UIColor {
    static var compatibleSystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }
}
