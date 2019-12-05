//
//  ProductsListViewController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


final class ProductsListViewController: ViewController<ProductsListView, ProductsListViewModel> {
    override func makeView() -> ProductsListView {
        return ProductsListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products"
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = logoutButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton
        
        v.tableView.register(cellType: ProductsListItemCell.self)
        let dataSource = RxTableViewSectionedReloadDataSource<SimpleSection<Product>>(
            configureCell: { (ds, tv, ip, item) -> UITableViewCell in
                let cell = tv.dequeue(ProductsListItemCell.self, for: ip)
                cell.configure(item)
                return cell
        })
        
        let input = ProductsListViewModelInput(
            items: v.tableView.rx.items(dataSource: dataSource),
            viewDidLoad: viewDidLoadReplayed,
            didTapLogout: logoutButton.rx.tap.asSignal(),
            didTapAdd: addButton.rx.tap.asSignal(),
            didSelectItemAt: v.tableView.rx.itemSelected.asSignal()
                .do(onNext: deselectItem(v.tableView))
                .map { $0.row }
        )
        viewModel(input).disposed(by: disposeBag)
    }
}

final class ProductsListView: UIView {
    private(set) lazy var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(tableView)
        
        tableView.rowHeight = 80
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = self.bounds
    }
}
