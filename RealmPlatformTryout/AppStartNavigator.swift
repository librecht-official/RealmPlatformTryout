//
//  AppStartNavigator.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 24/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxCocoa


enum AppMainRoute {
    case onboarding
    case login
    case main(User)
}

protocol AppStartNavigatorType: AnyObject {
    func start()
    func navigate(to route: AppMainRoute) -> Signal<Void>
}

final class AppStartNavigator: AppStartNavigatorType {
    let env = UnauthorizedRealmPlatformTryoutAppEnvironment()
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if let user = env.loginAPI.loggedInUser() {
            _ = navigate(to: .main(user))
        } else {
            _ = navigate(to: .login)
        }
    }
    
    func navigate(to route: AppMainRoute) -> Signal<Void> {
        switch route {
        case .onboarding:
            return onboarding()
        case .login:
            return login()
        case let .main(user):
            return main(user: user)
        }
    }
    
    func onboarding() -> Signal<Void> {
        let system = driveAppOnboardingFinish(env: env, navigator: self)
        let controller = AppOnboardingViewController(
            viewModel: AppOnboardingViewInput(
                hello: .loadFromNib(),
                features: .loadFromNib(),
                finishController: AppOnboardingFinishViewController(view: .loadFromNib(), system: system)
            )
        )
        
        window.rootViewController = controller
        window.makeKeyAndVisible()
        return .just(())
    }
    
    func login() -> Signal<Void> {
        let controller = UINavigationController()
        let factory = LoginVCFactory(env: env)
        let navigator = LoginNavigator(
            navigationController: controller,
            factory: factory,
            startNavigator: self
        )
        window.rootViewController = controller
        window.makeKeyAndVisible()
        return navigator.navigate(to: .login)
    }
    
    func main(user: User) -> Signal<Void> {
        let env = AuthorizedRealmPlatformTryoutAppEnvironment(user: user)
        let controller = MainViewController(env: env)
        let factory = MainVCFactory(env: env)
        let navigator = MainNavigator(
            navigationController: controller,
            factory: factory,
            delegate: self
        )
        window.rootViewController = controller
        window.makeKeyAndVisible()
        return navigator.navigate(to: .products)
    }
}

// MARK: - ProductsNavigatorDelegate

extension AppStartNavigator: MainNavigatorDelegate {
    func exitMain() -> Signal<Void> {
        return navigate(to: .login)
    }
}
