//
//  OrdersListItemView.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 03/11/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


final class OrdersListItemView: UIView {
    @IBOutlet var codeLabel: UILabel!
    @IBOutlet var createdDateLabel: UILabel!
    @IBOutlet var totalProductsLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var statusView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusView.layer.cornerRadius = statusView.bounds.height / 2
    }
}

final class OrdersListItemCell: TableViewCell<OrdersListItemView> {
    func configure(_ item: Order) {
        v.codeLabel.text = item.code
        v.createdDateLabel.text = DateFormatter.defaultDateTime.string(from: item.createdAt)
        v.totalProductsLabel.text = "Total products: \(item.productIds.count)"
        v.statusLabel.text = item.status.rawValue
        v.statusView.backgroundColor = statusColor(item)
    }
}

func statusColor(_ order: Order) -> UIColor {
    switch order.status {
    case .accepted: return UIColor.systemOrange
    case .processing: return UIColor.systemBlue
    case .done: return UIColor.systemGreen
    case .unknown: return UIColor.black
    }
}
