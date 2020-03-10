//
//  RxExt.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 10.03.2020.
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import RxSwift
import RxCocoa


extension Single {
    func toResultSignal() -> Signal<Result<Element, Error>> {
        self.asObservable()
            .map(Result<Element, Error>.success)
            .asSignal { error -> Signal<Result<Element, Error>> in
                .just(Result<Element, Error>.failure(error))
            }
    }
}
