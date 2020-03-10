//
//  AppOnboardingSystem.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 10/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback


struct AppOnboardingFinishBindingInput {
    let state: Binder<AppOnboardingFinish.State>
    
    let continueTap: Signal<Void>
    let retryButtonTap: Signal<Void>
}

typealias AppOnboardingFinishBinding = (AppOnboardingFinishBindingInput) -> Disposable
typealias AppOnboardingEnvironment = LoginAPIEnvironment

extension AppOnboardingFinish {
    static func run(
        env: AppOnboardingEnvironment,
        navigator: AppStartNavigatorType) -> AppOnboardingFinishBinding {
        
        typealias FeedbackLoop = Feedback.Loop<State, Command>
        
        return { input -> Disposable in
            let ui: FeedbackLoop = bind { state -> Bindings<Command> in
                return Bindings(
                    subscriptions: [
                        state.drive(input.state)
                    ],
                    events: [
                        input.continueTap.map { Command.continue },
                        input.retryButtonTap.map { Command.retry }
                    ]
                )
            }
            
            let effects: FeedbackLoop = react(
                request: { $0.effectRequest }, effects: performEffect(env: env, navigator: navigator)
            )
            
            let system = Driver.system(
                initialState: State(),
                reduce: reduce,
                feedback: [ui, effects]
            )
            return system.drive()
        }
    }
    
    static func performEffect(
        env: AppOnboardingEnvironment,
        navigator: AppStartNavigatorType) -> (Feedback.Request<Effect>) -> Signal<Command> {
        
        return { effectRequest in
            switch effectRequest.data {
            case .loginAsGuest:
                return env.loginAPI.loginAsGuest().toResultSignal().map { Command.didLogin($0) }
                
            case let .navigateToMain(user):
                _ = navigator.navigate(to: .main(user))
                return .never()
            }
        }
    }
}
