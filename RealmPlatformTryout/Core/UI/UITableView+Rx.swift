//
//  UITableView+Rx.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 27/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public func deselectItem(_ tableView: UITableView) -> (IndexPath) -> () {
    return {
        tableView.deselectRow(at: $0, animated: true)
    }
}
