//
//  MainViewController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 31/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


typealias MainEnvironment = LoginAPIEnvironment

final class MainViewController: UITabBarController {
    var navigator: MainNavigatorType!
    private var env: MainEnvironment
    private var productsController: UIViewController!
    private var ordersController: UIViewController!
    
    init(env: MainEnvironment) {
        self.env = env
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setControllers(
        products: UIViewController,
        orders: UIViewController) {
        
        self.productsController = products
        self.ordersController = orders
        
        products.tabBarItem = UITabBarItem(
            title: "Products",
            image: UIImage(named: "tab.products"),
            selectedImage: UIImage(named: "tab.products.filled")
        )
        orders.tabBarItem = UITabBarItem(
            title: "Orders",
            image: UIImage(named: "tab.orders"),
            selectedImage: UIImage(named: "tab.orders.filled")
        )
        
        self.viewControllers = [products, orders]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController == ordersController && env.loginAPI.isUserGuest() {
            _ = navigator.navigate(to: .loginOffer)
            return false
        }
        return true
    }
}
