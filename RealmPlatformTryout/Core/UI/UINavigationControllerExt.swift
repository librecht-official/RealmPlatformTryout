//
//  UINavigationControllerExt.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public extension UINavigationController {
    func push(_ viewController: UIViewController, animated: Bool) -> Signal<Void> {
        return resetStack(to: viewControllers + [viewController], animated: animated)
    }
    
    func resetStack(to viewControllers: [UIViewController], animated: Bool) -> Signal<Void> {
        if !animated {
            setViewControllers(viewControllers, animated: animated)
            return Signal.just(())
        }
        
        let subject = PublishSubject<Void>()
        setViewControllers(viewControllers, animated: animated)
        
        guard let coordinator = transitionCoordinator else {
            return Signal.just(())
        }
        coordinator.animate(alongsideTransition: nil) { _ in
            subject.onNext(())
            subject.onCompleted()
        }
        return subject.asSignal(onErrorSignalWith: Signal.empty())
    }
}
