//
//  UIViewExt.swift
//  XibBasedViews
//
//  Created by Vladislav Librecht on 21/09/2019.
//  Copyright © 2019 Vladislav Librecht. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib() -> Self {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        return bundle.loadNibNamed(nibName, owner: nil)!.first! as! Self
    }
}
