//
//  LoginViewController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 25/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class LoginViewController: ViewController<LoginView, LoginBinding> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v.usernameField.text = "User1"
        v.passwordField.text = "1234Q"
        
        let bindingInput = LoginBindingInput(
            username: v.usernameField.rx.text.orEmpty.asDriver(),
            password: v.passwordField.rx.text.orEmpty.asDriver(),
            login: v.loginButton.rx.tap.asSignal(),
            goToSignUp: v.signUpButton.rx.tap.asSignal(),
            loginAsGuest: v.guestButton.rx.tap.asSignal(),
            isLoading: v.isBusy,
            isLoginButtonEnabled: v.loginButton.rx.isEnabled
        )
        input(bindingInput).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

final class LoginView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var guestButton: UIButton!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var isBusy: Binder<Bool> {
        return Binder<Bool>(self) { (this, busy) in
            this.loadingIndicator.set(animating: busy)
            this.isUserInteractionEnabled = !busy
        }
    }
}
