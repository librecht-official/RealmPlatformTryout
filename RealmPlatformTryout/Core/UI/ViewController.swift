//
//  ViewController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 25/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


open class ViewController<View: UIView, ViewModel>: UIViewController {
    public private(set) var v: View!
    public let viewModel: ViewModel
    public let disposeBag = DisposeBag()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    open override func loadView() {
        let v: View = makeView()
        self.v = v
        view = v
    }
    
    open func makeView() -> View {
        return View.loadFromNib()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    private let viewDidLoadReplay = ReplaySubject<Void>.create(bufferSize: 1)
    var viewDidLoadReplayed: Signal<Void> {
        return viewDidLoadReplay.asSignal(onErrorSignalWith: .never())
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadReplay.onNext(())
    }
}
