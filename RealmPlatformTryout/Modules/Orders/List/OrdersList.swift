
//
//  OrdersList.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 02/11/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

enum OrdersList {
    struct State {
        var results = FetchResults<Order>()
        var isLoading: Bool = false
        
        var fetchRequest: FetchRequest?
    }
    
    enum Command {
        case viewDidLoad
        case didFetch(FetchResults<Order>)
    }
    
    static let initialState = State()
    
    static func reduce(state: State, command: Command) -> State {
        var newState = state
        switch command {
        case .viewDidLoad:
            newState.fetchRequest = FetchRequest()
            newState.isLoading = true
            
        case let .didFetch(results):
            newState.fetchRequest = nil
            newState.results = results
            newState.isLoading = false
        }
        return newState
    }
    
    // MARK: Auxiliary
    
    struct FetchRequest: Equatable {
    }
}
