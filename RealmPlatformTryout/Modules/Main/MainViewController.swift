//
//  MainViewController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 31/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


final class MainViewController: UITabBarController {
    var navigator: MainNavigatorType!
    
    func setControllers(
        products: UIViewController,
        orders: UIViewController) {
        
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
        
        viewControllers = [products, orders]
    }
}
