//
//  LoginViewModel.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 25/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback


struct LoginViewModelInput {
    let username: Driver<String>
    let password: Driver<String>
    let login: Signal<Void>
    let goToSignUp: Signal<Void>
    
    let isLoading: Binder<Bool>
    let isLoginButtonEnabled: Binder<Bool>
}

typealias LoginViewModel = (LoginViewModelInput) -> Disposable
typealias LoginEnvironment = LoginAPIEnvironment

func driveLoginView(env: LoginEnvironment, navigator: LoginNavigatorType) -> LoginViewModel {
    typealias Command = Login.Command
    typealias Feedback = CocoaFeedback<Login.State, Login.Command>
    
    return { view in
        let ui: Feedback = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    state.map { $0.isLoginEnabled }.drive(view.isLoginButtonEnabled),
                    state.map { $0.isLoading }.drive(view.isLoading)
                ],
                events: [
                    view.username.toSignal().map { Command.updateUsername($0) },
                    view.password.toSignal().map { Command.updatePassword($0) },
                    view.login.map { Command.login },
                    view.goToSignUp.map { Command.goToSignUp }
                ]
            )
        }
        
        let api: Feedback = react(request: { $0.loginRequest }) { request -> Signal<Command> in
            return env.loginAPI.login(
                username: request.username,
                password: request.password,
                register: false
            )
                .map { user in Command.didLogin(user) }
                .asSignal { error in
                    Signal.just(Command.didFailLogin(error))
                }
        }
        
        let navigation: Feedback = react(request: { $0.navigationRequest }) {
            route -> Signal<Command> in
            return navigator.navigate(to: route).map { Command.didNavigateTo(route) }
        }
        
        let system = Driver.system(
            initialState: Login.initialState,
            reduce: Login.reduce,
            feedback: [ui, api, navigation]
        )
        return system.drive()
    }
}
