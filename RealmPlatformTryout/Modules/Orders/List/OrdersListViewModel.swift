//
//  OrdersListViewModel.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 02/11/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources


struct OrdersListViewModelInput {
    let items: (Observable<[SimpleSection<Order>]>) -> Disposable
    let viewDidLoad: Signal<Void>
    let loadingIndicator: Binder<Bool>
}

typealias OrdersListViewModel = (OrdersListViewModelInput) -> Disposable
typealias OrdersListEnvironment = OrdersAPIEnvironment
    & LoginAPIEnvironment

func driveOrdersListView(env: OrdersListEnvironment, navigator: OrdersNavigatorType) -> OrdersListViewModel {
    typealias Command = OrdersList.Command
    typealias Feedback = CocoaFeedback<OrdersList.State, OrdersList.Command>
    
    return { view in
        let ui: Feedback = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    state.flatMap { $0.results.elements }
                        .map { [SimpleSection(items: $0)] }.drive(view.items),
                    state.map { $0.isLoading }.drive(view.loadingIndicator)
                ],
                events: [
                    view.viewDidLoad.map { Command.viewDidLoad }
                ]
            )
        }
        
        let fetch: Feedback = react(request: { $0.fetchRequest }) { request -> Signal<Command> in
            env.getOrdersDAO()
                .map { dao -> Command in
                    Command.didFetch(dao.fetch())
                }
                .asSignal { error -> Signal<Command> in
                    print(error)
                    return Signal.empty()
                }
        }
        
        let system = Driver.system(
            initialState: OrdersList.initialState,
            reduce: OrdersList.reduce,
            feedback: [ui, fetch]
        )
        return system.drive()
    }
}
