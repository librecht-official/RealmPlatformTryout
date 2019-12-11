//
//  AppOnboardingViewController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 09/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift


struct AppOnboardingViewInput {
    let hello: AppOnboardingHelloView
    let features: AppOnboardingFeaturesView
    let finishController: AppOnboardingFinishViewController
}

final class AppOnboardingViewController: ViewController<AppOnboardingView, AppOnboardingViewInput> {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindPaginatedScroll(v.scrollView, v.pageControl).disposed(by: disposeBag)
        v.set(views: [input.hello, input.features, input.finishController.view])
    }
}

final class AppOnboardingView: UIView {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var pageControl: UIPageControl!
    
    func set(views: [UIView]) {
        for view in views {
            stackView.addArrangedSubview(view)
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
    }
}
