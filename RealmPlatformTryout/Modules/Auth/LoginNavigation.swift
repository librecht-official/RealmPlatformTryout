//
//  LoginNavigation.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 24/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxCocoa


enum LoginRoute: Equatable {
    case login
    case signUp
    case main(User)
}

protocol LoginNavigatorType: AnyObject {
    func navigate(to route: LoginRoute) -> Signal<Void>
}

class LoginNavigator: LoginNavigatorType {
    weak var navigationController: UINavigationController!
    weak var startNavigator: AppStartNavigatorType!
    let factory: LoginVCFactory
    
    init(
        navigationController: UINavigationController,
        factory: LoginVCFactory,
        startNavigator: AppStartNavigatorType) {
        
        self.navigationController = navigationController
        self.factory = factory
        self.startNavigator = startNavigator
    }
    
    func navigate(to route: LoginRoute) -> Signal<Void> {
        switch route {
        case .login:
            let vc = factory.makeLoginViewController(navigator: self)
            return navigationController.resetStack(to: [vc], animated: true)
            
        case .signUp:
            let vc = factory.makeSignUpViewController(navigator: self)
            return navigationController.resetStack(to: [vc], animated: true)
            
        case let .main(user):
            return startNavigator.navigate(to: .main(user))
        }
    }
}

class LoginVCFactory {
    typealias Environment = LoginAPIEnvironment
    let env: Environment
    
    init(env: Environment) {
        self.env = env
    }
    
    func makeLoginViewController(navigator: LoginNavigatorType) -> UIViewController {
        let vm = driveLoginView(env: env, navigator: navigator)
        return LoginViewController(viewModel: vm)
    }
    
    func makeSignUpViewController(navigator: LoginNavigatorType) -> UIViewController {
        let vm = driveSignUpView(env: env, navigator: navigator)
        return SignUpViewController(viewModel: vm)
    }
}
