//
//  OrdersListViewController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 02/11/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


final class OrdersListViewController: ViewController<OrdersListView, OrdersListBinding> {
    override func makeView() -> OrdersListView {
        return OrdersListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Orders"
        
        v.tableView.register(cellType: OrdersListItemCell.self)
        let dataSource = RxTableViewSectionedReloadDataSource<SimpleSection<Order>>(
            configureCell: { (ds, tv, ip, item) -> UITableViewCell in
                let cell = tv.dequeue(OrdersListItemCell.self, for: ip)
                cell.configure(item)
                return cell
        })
        
        let bindingInput = OrdersListBindingInput(
            items: v.tableView.rx.items(dataSource: dataSource),
            viewDidLoad: viewDidLoadReplayed,
            loadingIndicator: v.isAnimating
        )
        input(bindingInput).disposed(by: disposeBag)
    }
}

final class OrdersListView: UIView {
    private(set) lazy var tableView = UITableView()
    private(set) lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(activityIndicator)
        addSubview(tableView)
        
        activityIndicator.hidesWhenStopped = true
        tableView.rowHeight = 80
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = self.bounds
        activityIndicator.center = self.center
    }
    
    var isAnimating: Binder<Bool> {
        return Binder(self) { (this, animating) in
            this.activityIndicator.set(animating: animating)
            this.tableView.isHidden = animating
        }
    }
}
