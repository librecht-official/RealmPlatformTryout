//
//  SignUpBinding.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback


struct SignUpBindingInput {
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

typealias SignUpBinding = (SignUpBindingInput) -> Disposable
typealias SignUpEnvironment = LoginAPIEnvironment

func signUpBinding(env: SignUpEnvironment, navigator: LoginNavigatorType) -> SignUpBinding {
    typealias Command = SignUp.Command
    typealias FeedbackLoop = Feedback.Loop<SignUp.State, SignUp.Command>
    
    return { input in
        let ui: FeedbackLoop = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    state.map { $0.isSignUpEnabled }.drive(input.isSignUpButtonEnabled),
                    state.map { $0.usernameMessage }.drive(input.usernameMessage),
                    state.map { $0.passwordMessage }.drive(input.passwordMessage),
                    state.map { $0.confirmPasswordMessage }.drive(input.confirmPasswordMessage),
                    state.map { $0.isLoading }.drive(input.isLoading)
                ],
                events: [
                    input.username.toSignal().map { Command.updateUsername($0) },
                    input.password.toSignal().map { Command.updatePassword($0) },
                    input.confirmPassword.toSignal().map { Command.updateConfirmPassword($0) },
                    input.goToLogin.map { Command.goToLogin },
                    input.signUp.map { Command.signUp }
                ]
            )
        }
        
        let api: FeedbackLoop = react(request: { $0.signUpRequest }) { request -> Signal<Command> in
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
        
        let navigation: FeedbackLoop = react(request: { $0.navigationRequest }) {
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
