//
//  ProductsListViewModel.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources


struct ProductsListViewModelInput {
    let items: (Observable<[SimpleSection<Product>]>) -> Disposable
    let viewDidLoad: Signal<Void>
    let didTapLogout: Signal<Void>
    let didTapAdd: Signal<Void>
    let didSelectItemAt: Signal<Int>
}

typealias ProductsListViewModel = (ProductsListViewModelInput) -> Disposable
typealias ProductsListEnvironment = ProductsAPIEnvironment
    & LoginAPIEnvironment

func driveProductsListView(env: ProductsListEnvironment, navigator: ProductsNavigatorType) -> ProductsListViewModel {
    typealias Command = ProductsList.Command
    typealias Feedback = CocoaFeedback<ProductsList.State, ProductsList.Command>
    
    return { view in
        let ui: Feedback = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    state.flatMap { $0.results.elements }
                        .map { [SimpleSection(items: $0)] }.drive(view.items)
                ],
                events: [
                    view.viewDidLoad.map { Command.viewDidLoad },
                    view.didTapAdd.map { Command.didTapAdd },
                    view.didSelectItemAt.map { Command.didSelectItemAt($0) }
                ]
            )
        }
        
        let fetch: Feedback = react(request: { $0.fetchRequest }) { request -> Signal<Command> in
            return Signal.just(Command.didFetch(env.productsDAO.fetch()))
        }
        
        let edit: Feedback = react(request: { $0.openEditor }) { request -> Signal<Command> in
            return navigator.navigate(to: .editor(request.value)).map { Command.didOpenEditor }
        }
        
        let logoutDisposable = view.didTapLogout
            .emit(onNext: {
                env.loginAPI.logout()
                _ = navigator.navigate(to: .logout)
            })
        
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
