//
//  ProductsList.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation


enum ProductsList {
    struct State {
        var results: FetchResults<Product>
        
        var fetchRequest: FetchRequest?
        var openEditor: Request<Product?>?
    }
    
    enum Command {
        case viewDidLoad
        case didFetch(FetchResults<Product>)
        case didTapAdd
        case didSelectItemAt(Int)
        case didOpenEditor
    }
    
    static let initialState = State(results: .init())
    
    static func reduce(state: State, command: Command) -> State {
        var newState = state
        switch command {
        case .viewDidLoad:
            newState.fetchRequest = FetchRequest()
            
        case let .didFetch(results):
            newState.results = results
            newState.fetchRequest = nil
            
        case .didTapAdd:
            newState.openEditor = Request(nil)
            
        case let .didSelectItemAt(index):
            let item = newState.results.currentElements[index]
            newState.openEditor = Request(item)
        
        case .didOpenEditor:
            newState.openEditor = nil
        }
        return newState
    }
    
    // MARK: Auxiliary
    
    struct FetchRequest: Equatable {
    }
}
