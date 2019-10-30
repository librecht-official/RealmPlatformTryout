//
//  ProductsNavigation.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 24/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxCocoa


enum ProductsRoute {
    case logout
    case list
    case editor(Product?)
}

protocol ProductsNavigatorType {
    func navigate(to route: ProductsRoute) -> Signal<Void>
}

protocol ProductsNavigatorDelegate: AnyObject {
    func logout() -> Signal<Void>
}

final class ProductsNavigator: ProductsNavigatorType {
    weak var navigationController: UINavigationController!
    weak var delegate: ProductsNavigatorDelegate!
    let factory: ProductsVCFactory
    
    init(
        navigationController: UINavigationController,
        factory: ProductsVCFactory,
        delegate: ProductsNavigatorDelegate) {
        
        self.navigationController = navigationController
        self.factory = factory
        self.delegate = delegate
    }
    
    func navigate(to route: ProductsRoute) -> Signal<Void> {
        switch route {
        case .list:
            let vc = factory.makeProductsListViewController(navigator: self)
            return navigationController.resetStack(to: [vc], animated: true)
            
        case .logout:
            return delegate.logout()
            
        case let .editor(product):
            let editor = factory.makeProductEditorViewController(navigator: self, product: product)
            return navigationController.presentModal(editor, animated: true)
        }
    }
}

final class ProductsVCFactory {
    typealias Environment = AuthorizedAppEnvironment
    let env: Environment
    init(env: Environment) {
        self.env = env
    }
    
    func makeProductsListViewController(navigator: ProductsNavigatorType) -> UIViewController {
        let vm = driveProductsListView(env: env, navigator: navigator)
        return ProductsListViewController(viewModel: vm)
    }
    
    func makeProductEditorViewController(navigator: ProductsNavigatorType, product: Product?) -> UIViewController {
        return editorAlert(env: env, product: product)
    }
}
