//
//  OrdersListBinding.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 02/11/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources


struct OrdersListBindingInput {
    let items: (Observable<[SimpleSection<Order>]>) -> Disposable
    let viewDidLoad: Signal<Void>
    let loadingIndicator: Binder<Bool>
}

typealias OrdersListBinding = (OrdersListBindingInput) -> Disposable
typealias OrdersListEnvironment = OrdersAPIEnvironment
    & LoginAPIEnvironment

func ordersListBinding(env: OrdersListEnvironment, navigator: OrdersNavigatorType) -> OrdersListBinding {
    typealias Command = OrdersList.Command
    typealias FeedbackLoop = Feedback.Loop<OrdersList.State, OrdersList.Command>
    
    return { input in
        let ui: FeedbackLoop = bind { state -> Bindings<Command> in
            return Bindings(
                subscriptions: [
                    state.flatMap { $0.results.elements }
                        .map { [SimpleSection(items: $0)] }.drive(input.items),
                    state.map { $0.isLoading }.drive(input.loadingIndicator)
                ],
                events: [
                    input.viewDidLoad.map { Command.viewDidLoad }
                ]
            )
        }
        
        let fetch: FeedbackLoop = react(request: { $0.fetchRequest }) { request -> Signal<Command> in
            env.getOrdersDAO()
                .map { dao -> Command in
                    Command.didFetch(dao.fetch())
                }
                .asSignal { error -> Signal<Command> in
                    // TODO: handle error
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
