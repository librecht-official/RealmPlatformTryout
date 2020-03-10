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
            state: view.state,
            continueTap: view.continueButton.rx.tap.asSignal(),
            retryButtonTap: view.retryButton.rx.tap.asSignal()
        )
        binding(input).disposed(by: disposeBag)
    }
}


final class AppOnboardingFinishView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    var state: Binder<AppOnboardingFinish.State> {
        return Binder<AppOnboardingFinish.State>(self) { (this, state) in
            this.titleLabel.text = state.title
            this.descriptionLabel.text = state.descriptionText
            
            this.continueButton.setTitle(state.continueButtonTitle, for: .normal)
            this.continueButton.isEnabled = state.continueButtonEnabled
            this.continueButton.backgroundColor = state.continueButtonEnabled ?
                UIColor.systemBlue : UIColor.lightGray
            this.continueButton.isHidden = state.continueButtonHidden
            this.activityIndicator.set(animating: state.continueButtonActivityIndicator)
            
            this.activityIndicator.color = state.continueButtonHidden ? UIColor.gray : UIColor.white
            
            this.retryButton.setTitle(state.retryButtonTitle, for: .normal)
            this.retryButton.isHidden = state.retryButtonHidden
            
            this.errorLabel.text = state.errorMessage
        }
    }
}
