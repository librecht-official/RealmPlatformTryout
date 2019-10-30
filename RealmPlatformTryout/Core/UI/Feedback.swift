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


public typealias CocoaFeedback<State, Command> = (Driver<State>) -> Signal<Command>

extension Driver {
    func toSignal() -> Signal<Element> {
        return self.asSignal(onErrorSignalWith: .never())
    }
}
