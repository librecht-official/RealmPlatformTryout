//
//  SignUpViewModel.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback


struct SignUpViewModelInput {
    let username: Driver<String>
    let password: Driver<String>
    let confirmPassword: Driver<String>
    let goToLogin: Signal<Void>
    let signUp: Signal<Void>
    
    let isLoading: Binder<Bool>
    let isSignUpButtonEnabled: Binder<Bool>
    let usernameMessage: Binder<FieldMessage?>
    let passwordMessage: Binder<FieldMessage?>
    let confirmPasswordMessage: Binder<FieldMessage?>
}

typealias SignUpViewModel = (SignUpViewModelInput) -> Disposable
typealias SignUpEnvironment = LoginAPIEnvironment

func driveSignUpView(env: SignUpEnvironment, navigator: LoginNavigatorType) -> SignUpViewModel {
    typealias Command = SignUp.Command
    typealias Feedback = CocoaFeedback<SignUp.State, SignUp.Command>
    
    return { view in
        let ui: Feedback = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    state.map { $0.isSignUpEnabled }.drive(view.isSignUpButtonEnabled),
                    state.map { $0.usernameMessage }.drive(view.usernameMessage),
                    state.map { $0.passwordMessage }.drive(view.passwordMessage),
                    state.map { $0.confirmPasswordMessage }.drive(view.confirmPasswordMessage),
                    state.map { $0.isLoading }.drive(view.isLoading)
                ],
                events: [
                    view.username.toSignal().map { Command.updateUsername($0) },
                    view.password.toSignal().map { Command.updatePassword($0) },
                    view.confirmPassword.toSignal().map { Command.updateConfirmPassword($0) },
                    view.goToLogin.map { Command.goToLogin },
                    view.signUp.map { Command.signUp }
                ]
            )
        }
        
        let api: Feedback = react(request: { $0.signUpRequest }) { request -> Signal<Command> in
            return env.loginAPI.login(
                username: request.username,
                password: request.password,
                register: true
            )
                .map { user in Command.didSignUp(user) }
                .asSignal { error in
                    Signal.just(Command.didFailSignUp(error))
                }
        }
        
        let navigation: Feedback = react(request: { $0.navigationRequest }) {
            route -> Signal<Command> in
            return navigator.navigate(to: route).map { Command.didNavigateTo(route) }
        }
        
        let system = Driver.system(
            initialState: SignUp.initialState,
            reduce: SignUp.reduce,
            feedback: [ui, api, navigation]
        )
        return system.drive()
    }
}
