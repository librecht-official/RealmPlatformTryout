//
//  OrdersNavigation.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 02/11/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxCocoa


enum OrdersRoute {
    case list
}

protocol OrdersNavigatorType {
    func navigate(to route: OrdersRoute) -> Signal<Void>
}

protocol OrdersNavigatorDelegate: AnyObject {
    
}

final class OrdersNavigator: OrdersNavigatorType {
    weak var navigationController: UINavigationController!
    weak var delegate: OrdersNavigatorDelegate!
    let factory: OrdersVCFactory
    
    init(
        navigationController: UINavigationController,
        factory: OrdersVCFactory,
        delegate: OrdersNavigatorDelegate) {
        
        self.navigationController = navigationController
        self.factory = factory
        self.delegate = delegate
    }
    
    func navigate(to route: OrdersRoute) -> Signal<Void> {
        switch route {
        case .list:
            let vc = factory.makeOrdersListViewController(navigator: self)
            return navigationController.resetStack(to: [vc], animated: true)
        }
    }
}

final class OrdersVCFactory {
    typealias Environment = AuthorizedAppEnvironment
    let env: Environment
    init(env: Environment) {
        self.env = env
    }
    
    func makeOrdersListViewController(navigator: OrdersNavigatorType) -> UIViewController {
        let vm = driveOrdersListView(env: env, navigator: navigator)
        return OrdersListViewController(viewModel: vm)
    }
}
