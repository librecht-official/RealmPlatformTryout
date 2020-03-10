//
//  Feedback.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 25/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback


enum Feedback {
    public typealias Loop<State, Command> = (Driver<State>) -> Signal<Command>
    
    struct EmptyRequest: Equatable {
        let id = UUID()
    }
    
    struct Request<T>: Equatable {
        let id = UUID()
        let data: T
        
        init(_ data: T) {
            self.data = data
        }
        
        static func == (lhs: Feedback.Request<T>, rhs: Feedback.Request<T>) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension Driver {
    func toSignal() -> Signal<Element> {
        return self.asSignal(onErrorSignalWith: .never())
    }
}
