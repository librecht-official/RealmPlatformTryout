//
//  MainContainerController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 11/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class MainContainerController: UIViewController {
    private var current: UIViewController?
    
    func set(viewController: UIViewController) -> Signal<Void> {
        guard viewController != current else {
            return Signal.just(())
        }
        
        let subject = PublishSubject<Void>()
        
        let previous = current
        current = viewController
        
        addChild(viewController)
        
        if let previous = previous {
            previous.willMove(toParent: nil)
            UIView.transition(
                from: previous.view,
                to: viewController.view,
                duration: 0.5,
                options: [.curveEaseOut, .transitionFlipFromRight]) { _ in
                    viewController.didMove(toParent: self)
                    previous.removeFromParent()
                    subject.onNext(())
                    subject.onCompleted()
            }
        } else {
            view.addSubview(viewController.view)
            viewController.view.frame = self.view.bounds
            viewController.didMove(toParent: self)
            subject.onNext(())
            subject.onCompleted()
        }
        
        return subject.asSignal(onErrorSignalWith: Signal.empty())
    }
    
    override func viewDidLayoutSubviews() {
        current?.view.frame = self.view.bounds
        super.viewDidLayoutSubviews()
    }
}
