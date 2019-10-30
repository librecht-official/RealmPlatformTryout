//
//  UIViewExt.swift
//  XibBasedViews
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

extension UIView {
    static func loadFromNib<T: UIView>() -> T {
        let nibName = String(describing: T.self)
        let bundle = Bundle(for: T.self)
        return bundle.loadNibNamed(nibName, owner: nil)!.first! as! T
    }
}
