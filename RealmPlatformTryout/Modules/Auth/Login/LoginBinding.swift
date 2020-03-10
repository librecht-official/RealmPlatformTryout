//
//  LoginBinding.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 25/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback


struct LoginBindingInput {
    let username: Driver<String>
    let password: Driver<String>
    let login: Signal<Void>
    let goToSignUp: Signal<Void>
    let loginAsGuest: Signal<Void>
    
    let isLoading: Binder<Bool>
    let isLoginButtonEnabled: Binder<Bool>
}

typealias LoginBinding = (LoginBindingInput) -> Disposable
typealias LoginEnvironment = LoginAPIEnvironment

func loginBinding(env: LoginEnvironment, navigator: LoginNavigatorType) -> LoginBinding {
    typealias Command = Login.Command
    typealias FeedbackLoop = Feedback.Loop<Login.State, Login.Command>
    
    return { input in
        let ui: FeedbackLoop = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    state.map { $0.isLoginEnabled }.drive(input.isLoginButtonEnabled),
                    state.map { $0.isLoading }.drive(input.isLoading)
                ],
                events: [
                    input.username.toSignal().map { Command.updateUsername($0) },
                    input.password.toSignal().map { Command.updatePassword($0) },
                    input.login.map { Command.login },
                    input.goToSignUp.map { Command.goToSignUp },
                    input.loginAsGuest.map { Command.loginAsGuest }
                ]
            )
        }
        
        let api: FeedbackLoop = react(request: { $0.loginRequest }) { request -> Signal<Command> in
            return login(env, request)
                .map { user in Command.didLogin(user) }
                .asSignal { error in
                    Signal.just(Command.didFailLogin(error))
                }
        }
        
        let navigation: FeedbackLoop = react(request: { $0.navigationRequest }) {
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

func login(_ env: LoginEnvironment, _ request: Login.LoginRequest) -> Single<User> {
    switch request {
    case let .user(username, password):
        return env.loginAPI.login(username: username, password: password, register: false)
    case .guest:
        if env.loginAPI.isUserGuest(), let guestUser = env.loginAPI.loggedInUser() {
            return .just(guestUser)
        }
        return env.loginAPI.loginAsGuest()
    }
}
