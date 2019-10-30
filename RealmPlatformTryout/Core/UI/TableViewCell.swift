//
//  TableViewCell.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


open class TableViewCell<View: UIView>: UITableViewCell, Reusable {
    private(set) lazy var v: View = View.loadFromNib()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(v)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        v.frame = contentView.bounds
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
