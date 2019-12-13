//
//  AppOnboardingFinishView.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 09/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class AppOnboardingFinishViewController {
    let view: AppOnboardingFinishView
    let disposeBag = DisposeBag()
    
    init(view: AppOnboardingFinishView, binding: AppOnboardingFinishBinding) {
        self.view = view
        
        view.continueButton.layer.cornerRadius = 10
        view.continueButton.isEnabled = false
        
        let input = AppOnboardingFinishBindingInput(
            continueTap: view.continueButton.rx.tap.asSignal(),
            continueButtonEnabled: view.isReady
        )
        binding(input).disposed(by: disposeBag)
    }
}


final class AppOnboardingFinishView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitle("Finishing...", for: .disabled)
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    var isReady: Binder<Bool> {
        return Binder<Bool>(self) { (this, ready) in
            this.continueButton.isEnabled = ready
            this.continueButton.backgroundColor = ready ? UIColor.systemBlue : UIColor.lightGray
            this.activityIndicator.set(animating: !ready)
            this.titleLabel.text = ready ? "Done" : "We are almost done"
            this.descriptionLabel.text = ready ? "You are ready to go!" : "Synchronizing your Realm with Cloud so you could use it offline later. It may take some time."
        }
    }
}
