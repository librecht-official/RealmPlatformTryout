//
//  FetchResults.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 24/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa


public final class FetchResults<Element: RealmPersistable> {
    public var currentElements: [Element] {
        return elementsRelay.value
    }
    public var elements: Driver<[Element]> {
        return elementsRelay.asDriver()
    }
    private let elementsRelay = BehaviorRelay<[Element]>(value: [])
    private let results: Results<Element.ObjectType>?
    private var notificationToken: NotificationToken?
    
    public init(_ results: Results<Element.ObjectType>) {
        self.results = results
        self.notificationToken = results.observe { [weak self] change in
            let elements = Array(results.map { Element(object: $0) })
            self?.elementsRelay.accept(elements)
        }
    }
    
    public init() {
        self.results = nil
        self.notificationToken = nil
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
