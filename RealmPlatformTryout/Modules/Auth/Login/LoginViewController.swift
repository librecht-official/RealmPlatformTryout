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


final class LoginViewController: ViewController<LoginView, LoginViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        v.usernameField.text = "User1"
        v.passwordField.text = "1234Q"
        
        let input = LoginViewModelInput(
            username: v.usernameField.rx.text.orEmpty.asDriver(),
            password: v.passwordField.rx.text.orEmpty.asDriver(),
            login: v.loginButton.rx.tap.asSignal(),
            goToSignUp: v.signUpButton.rx.tap.asSignal(),
            isLoading: v.loadingIndicator.rx.isAnimating,
            isLoginButtonEnabled: v.loginButton.rx.isEnabled
        )
        viewModel(input).disposed(by: disposeBag)
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
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
}
