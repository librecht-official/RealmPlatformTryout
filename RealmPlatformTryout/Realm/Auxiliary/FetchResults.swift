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
    private let results: Results<Element.ObjectType>?
    
    public init(_ results: Results<Element.ObjectType>?) {
        self.results = results
    }
}

// MARK: - Querying

extension FetchResults where Element: Queryable {
    public func filter(query: Element.Query) -> FetchResults<Element> {
        return FetchResults(results?.filter(query.predicate))
    }
}

// MARK: - Sortable

extension FetchResults where Element: Sortable {
    public func sort(by: Element.SortBy) -> FetchResults<Element> {
        let d = by.sortDescriptor
        return FetchResults(results?.sorted(byKeyPath: d.keyPath, ascending: d.ascending))
    }
}

// MARK: - Live

extension FetchResults {
    func live() -> LiveFetchResults<Element> {
        guard let results = results else { return LiveFetchResults() }
        return LiveFetchResults(results)
    }
}

public final class LiveFetchResults<Element: RealmPersistable> {
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
        self.notificationToken = results.safelyObserve { [weak self] change in
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

extension Results where Element: RealmCollectionValue {
    /// Same as .observe, but the block is called after write transaction was commited.
    func safelyObserve(_ block: @escaping (RealmSwift.RealmCollectionChange<RealmSwift.Results<Element>>) -> Void) -> RealmSwift.NotificationToken {
        let dispatchQueue = OperationQueue.current?.underlyingQueue ?? DispatchQueue.main
        return self.observe { change in
            dispatchQueue.async {
                block(change)
            }
        }
    }
}
