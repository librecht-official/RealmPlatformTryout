//
//  UIViewControllerExt.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension UIViewController {
    func presentModal(_ viewController: UIViewController, animated: Bool) -> Signal<Void> {
        let subject = PublishSubject<Void>()
        self.present(viewController, animated: animated) {
            subject.onNext(())
            subject.onCompleted()
        }
        return subject.asSignal(onErrorSignalWith: Signal.empty())
    }
}

extension Reactive where Base: UIViewController {
    var didAppear: ControlEvent<Void> {
        let events = self.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
            .map { _ in () }
        return ControlEvent(events: events)
    }

    var didDisappear: ControlEvent<Void> {
        let events = self.methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
            .map { _ in () }
        return ControlEvent(events: events)
    }

    var willAppear: ControlEvent<Void> {
        let events = self.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in () }.debug()
        return ControlEvent(events: events)
    }

    var willDisappear: ControlEvent<Void> {
        let events = self.methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
            .map { _ in () }
        return ControlEvent(events: events)
    }
}
