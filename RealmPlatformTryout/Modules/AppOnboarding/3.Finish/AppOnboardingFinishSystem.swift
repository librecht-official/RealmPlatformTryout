//
//  AppOnboardingSystem.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 10/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa


struct AppOnboardingFinishBindingInput {
    let continueTap: Signal<Void>
    let continueButtonEnabled: Binder<Bool>
}

typealias AppOnboardingFinishBinding = (AppOnboardingFinishBindingInput) -> Disposable
typealias AppOnboardingEnvironment = LoginAPIEnvironment

func bindAppOnboardingFinish(
    env: AppOnboardingEnvironment,
    navigator: AppStartNavigatorType) -> AppOnboardingFinishBinding {
    
    return { input -> Disposable in
        let loggedIn = env.loginAPI.loginAsGuest().asObservable()
            .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
            .do(onNext: { _ in
                input.continueButtonEnabled.onNext(true)
            })
        
        let `continue` = Observable.combineLatest(
            loggedIn,
            input.continueTap.asObservable()
        ) { (user, _) in user }
        
        return `continue`.subscribe(onNext: { user in
            _ = navigator.navigate(to: .main(user))
        })
    }
}
