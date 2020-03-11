//
//  ProductsListBinding.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources


struct ProductsListBindingInput {
    let leftNavButtonTitle: Binder<String>
    let rightNavButtonAvailable: Binder<Bool>
    let items: (Observable<[SimpleSection<Product>]>) -> Disposable
    let viewDidLoad: Signal<Void>
    let didTapLogout: Signal<Void>
    let didTapAdd: Signal<Void>
    let allowsItemsSelection: Binder<Bool>
    let didSelectItemAt: Signal<Int>
    let logoutInProgress: Binder<Bool>
}

typealias ProductsListBinding = (ProductsListBindingInput) -> Disposable
typealias ProductsListEnvironment = ProductsAPIEnvironment
    & LoginAPIEnvironment

func productsListBinding(
    env: ProductsListEnvironment, navigator: ProductsNavigatorType) -> ProductsListBinding {
    typealias Command = ProductsList.Command
    typealias FeedbackLoop = Feedback.Loop<ProductsList.State, ProductsList.Command>
    
    return { input in
        let ui: FeedbackLoop = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    state.map { $0.leftNavButtonTitle }.drive(input.leftNavButtonTitle),
                    state.map { $0.rightNavButtonAvailable }.drive(input.rightNavButtonAvailable),
                    state.map { $0.allowsItemsSelection }.drive(input.allowsItemsSelection),
                    state.flatMap { $0.results.elements }
                        .map { [SimpleSection(items: $0)] }.drive(input.items)
                ],
                events: [
                    input.viewDidLoad.map { Command.viewDidLoad },
                    input.didTapAdd.map { Command.didTapAdd },
                    input.didSelectItemAt.map { Command.didSelectItemAt($0) }
                ]
            )
        }
        
        let fetch: FeedbackLoop = react(request: { $0.fetchRequest }) { request -> Signal<Command> in
            let results = env.productsDAO.fetch().live()
            return Signal.just(Command.didFetch(results))
        }
        
        let edit: FeedbackLoop = react(request: { $0.openEditor }) { request -> Signal<Command> in
            return navigator.navigate(to: .editor(request.value)).map { Command.didOpenEditor }
        }
        
        // "Take a short cut" here bypassing Login.State. Not sure if that's good, but takes less code...
        let logoutSystem = bindLogout(
            env, navigator,
            logoutSignal: input.didTapLogout,
            logoutInProgress: input.logoutInProgress
        )
        
        let system = Driver.system(
            initialState: ProductsList.initialState(isUserGuest: env.loginAPI.isUserGuest()),
            reduce: ProductsList.reduce,
            feedback: [ui, fetch, edit]
        )
        return Disposables.create(logoutSystem.emit(), system.drive())
    }
}

struct SimpleSection<Item>: SectionModelType {
    var items: [Item]
    
    init(original: SimpleSection<Item>, items: [Item]) {
        self = original
        self.items = items
    }
    
    init(items: [Item]) {
        self.items = items
    }
}

func bindLogout(
    _ env: LoginAPIEnvironment,
    _ navigator: ProductsNavigatorType,
    logoutSignal: Signal<Void>,
    logoutInProgress: Binder<Bool>) -> Signal<Void> {
    
    return logoutSignal
        .flatMap { _ -> Signal<Void> in
            if env.loginAPI.isUserGuest() {
                return Signal.just(())
            }
            env.loginAPI.logout()
            logoutInProgress.onNext(true)
            return env.loginAPI.loginAsGuest().map { _ in () }.asSignal(onErrorJustReturn: ())
        }
        .flatMap { _ -> Signal<Void> in
            logoutInProgress.onNext(false)
            return navigator.navigate(to: .logout)
        }
}
