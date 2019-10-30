//
//  OrdersListItemView.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 03/11/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


final class OrdersListItemCell: UITableViewCell, Reusable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: Order) {
        textLabel?.text = item.code
        let createdAt = DateFormatter.defaultDateTime.string(from: item.createdAt)
        detailTextLabel?.text = "Created at: \(createdAt). Total products: \(item.productIds.count)"
    }
}

