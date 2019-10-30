//
//  ProductsListItemView.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


final class ProductsListItemView: UIView {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
}

final class ProductsListItemCell: TableViewCell<ProductsListItemView> {
    func configure(_ item: Product) {
        v.nameLabel.text = item.name
        v.descLabel.text = item.desc
    }
}
