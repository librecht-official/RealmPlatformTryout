//
//  MainNavigation.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 31/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxCocoa


enum MainRoute {
    case products
    case orders
    case loginOffer
}

protocol MainNavigatorType {
    func navigate(to route: MainRoute) -> Signal<Void>
}

protocol MainNavigatorDelegate: AnyObject {
    func exitMain() -> Signal<Void>
}

final class MainNavigator: MainNavigatorType {
    weak var navigationController: MainViewController!
    weak var delegate: MainNavigatorDelegate!
    let factory: MainVCFactory
    
    init(
        navigationController: MainViewController,
        factory: MainVCFactory,
        delegate: MainNavigatorDelegate) {
        
        self.navigationController = navigationController
        self.factory = factory
        self.delegate = delegate
        navigationController.navigator = self
        
        let products = factory.makeProductsRootController(delegate: self)
        let orders = factory.makeOrdersRootController(delegate: self)
        navigationController.setControllers(products: products, orders: orders)
    }
    
    func navigate(to route: MainRoute) -> Signal<Void> {
        switch route {
        case .products:
            navigationController.selectedIndex = 0
            return .empty()
            
        case .orders:
            navigationController.selectedIndex = 1
            return .empty()
            
        case .loginOffer:
            let alert = UIAlertController(
                title: "You need to sign in to view your orders",
                message: nil,
                preferredStyle: .alert
            )
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            let login = UIAlertAction(title: "Sign in", style: .default) { [weak self] _ in
                _ = self?.logout()
            }
            alert.addAction(login)
            return navigationController.presentModal(alert, animated: true)
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
}

// MARK: - ProductsNavigatorDelegate

extension MainNavigator: ProductsNavigatorDelegate {
    func logout() -> Signal<Void> {
        return delegate.exitMain()
    }
}

// MARK: - OrdersNavigatorDelegate

extension MainNavigator: OrdersNavigatorDelegate {
}

// MARK: - MainVCFactory

final class MainVCFactory {
    typealias Environment = AuthorizedAppEnvironment
    let env: Environment
    init(env: Environment) {
        self.env = env
    }
    
    func makeProductsRootController(delegate: ProductsNavigatorDelegate) -> UIViewController {
        let controller = UINavigationController()
        controller.navigationBar.prefersLargeTitles = true
        let factory = ProductsVCFactory(env: env)
        let navigator = ProductsNavigator(
            navigationController: controller,
            factory: factory,
            delegate: delegate
        )
        _ = navigator.navigate(to: .list)
        
        return controller
    }
    
    func makeOrdersRootController(delegate: OrdersNavigatorDelegate) -> UIViewController {
        let controller = UINavigationController()
        controller.navigationBar.prefersLargeTitles = true
        let factory = OrdersVCFactory(env: env)
        let navigator = OrdersNavigator(
            navigationController: controller,
            factory: factory,
            delegate: delegate
        )
        _ = navigator.navigate(to: .list)
        
        return controller
    }
}
