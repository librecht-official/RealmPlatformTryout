//
//  PaginatedScroll.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 10/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


func bindPaginatedScroll(_ scrollView: UIScrollView, _ pageControl: UIPageControl) -> Disposable {
    let d1 = scrollView.rx.didEndDecelerating.asSignal()
        .map {
            scrollView.contentOffset.x
                / scrollView.contentSize.width
                * CGFloat(pageControl.numberOfPages)
                |> Int.init
        }
        .emit(to: pageControl.rx.currentPage)
    
    let d2 = pageControl.rx.controlEvent(UIControl.Event.valueChanged).asSignal()
        .map {
            CGFloat(pageControl.currentPage)
                * scrollView.contentSize.width
                / CGFloat(pageControl.numberOfPages) }
        .emit(onNext: { offsetX in
            var offset = scrollView.contentOffset
            offset.x = offsetX
            scrollView.setContentOffset(offset, animated: true)
        })
    
    return Disposables.create([d1, d2])
}
