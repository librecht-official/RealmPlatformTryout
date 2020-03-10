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
    private let controller = MainContainerController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        if let user = env.loginAPI.loggedInUser() {
            _ = navigate(to: .main(user))
        } else {
            _ = navigate(to: .onboarding)
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
        let binding = AppOnboardingFinish.run(env: env, navigator: self)
        let vc = AppOnboardingViewController(
            input: AppOnboardingViewInput(
                hello: .loadFromNib(),
                features: .loadFromNib(),
                finishController: AppOnboardingFinishViewController(view: .loadFromNib(), binding: binding)
            )
        )
        return controller.set(viewController: vc)
    }
    
    func login() -> Signal<Void> {
        let nc = UINavigationController()
        let factory = LoginVCFactory(env: env)
        let navigator = LoginNavigator(
            navigationController: nc,
            factory: factory,
            startNavigator: self
        )
        _ = controller.set(viewController: nc)
        return navigator.navigate(to: .login)
    }
    
    func main(user: User) -> Signal<Void> {
        let env = AuthorizedRealmPlatformTryoutAppEnvironment(user: user)
        let nc = MainViewController(env: env)
        let factory = MainVCFactory(env: env)
        let navigator = MainNavigator(
            navigationController: nc,
            factory: factory,
            delegate: self
        )
        _ = controller.set(viewController: nc)
        return navigator.navigate(to: .products)
    }
}

// MARK: - ProductsNavigatorDelegate

extension AppStartNavigator: MainNavigatorDelegate {
    func exitMain() -> Signal<Void> {
        return navigate(to: .login)
    }
}
