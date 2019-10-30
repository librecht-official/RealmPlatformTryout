//
//  UseCaseViewModel.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback


struct <#UseCase#>ViewModelInput {
    
}

typealias <#UseCase#>ViewModel = (<#UseCase#>ViewModelInput) -> Disposable
typealias <#UseCase#>Environment = Environemnt1
    & Environemnt2
    & Environemnt3

func drive<#UseCase#>View(env: <#UseCase#>Environment, navigator: NavigatorType) -> <#UseCase#>ViewModel {
    typealias Command = <#UseCase#>.Command
    typealias Feedback = CocoaFeedback<<#UseCase#>.State, <#UseCase#>.Command>
    
    return { view in
        let ui: Feedback = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    // state.map { $0.some }.drive(view.some)
                ],
                events: [
                    // view.some.toSignal().map { Command.some($0) }
                ]
            )
        }
        
//        let api: Feedback = react(request: { $0.signUpRequest }) { request -> Signal<Command> in
//            print(request)
//
//        }
        
//        let navigation: Feedback = react(request: { $0.navigationRequest }) {
//            request -> Signal<Command> in
//            return navigator.navigate(to: request).map { Command.some }
//        }
        
        let system = Driver.system(
            initialState: <#UseCase#>.initialState,
            reduce: <#UseCase#>.reduce,
            feedback: ui, api, navigation
        )
        return system.drive()
    }
}
