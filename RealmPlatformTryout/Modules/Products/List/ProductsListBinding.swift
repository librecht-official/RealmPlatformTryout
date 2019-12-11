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
    let didSelectItemAt: Signal<Int>
}

typealias ProductsListBinding = (ProductsListBindingInput) -> Disposable
typealias ProductsListEnvironment = ProductsAPIEnvironment
    & LoginAPIEnvironment

func productsListBinding(
    env: ProductsListEnvironment, navigator: ProductsNavigatorType) -> ProductsListBinding {
    typealias Command = ProductsList.Command
    typealias Feedback = CocoaFeedback<ProductsList.State, ProductsList.Command>
    
    return { input in
        let ui: Feedback = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
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
        
        let fetch: Feedback = react(request: { $0.fetchRequest }) { request -> Signal<Command> in
            return Signal.just(Command.didFetch(env.productsDAO.fetch()))
        }
        
        let edit: Feedback = react(request: { $0.openEditor }) { request -> Signal<Command> in
            return navigator.navigate(to: .editor(request.value)).map { Command.didOpenEditor }
        }
        
        let logoutDisposable = input.didTapLogout
            .emit(onNext: {
                _ = navigator.navigate(to: .logout)
            })
        
        let leftNavButtonTitle = env.loginAPI.isUserGuest() ? "Sign in" : "Log out"
        input.leftNavButtonTitle.onNext(leftNavButtonTitle)
        
        input.rightNavButtonAvailable.onNext(!env.loginAPI.isUserGuest())
        
        let system = Driver.system(
            initialState: ProductsList.initialState,
            reduce: ProductsList.reduce,
            feedback: [ui, fetch, edit]
        )
        return Disposables.create(logoutDisposable, system.drive())
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
