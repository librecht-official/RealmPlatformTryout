//
//  UIActivityIndicatorViewExt.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 05/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func set(animating: Bool) {
        if animating {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}
