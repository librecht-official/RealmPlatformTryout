//
//  SignUpViewController.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


final class SignUpViewController: ViewController<SignUpView, SignUpBinding> {
    override func viewDidLoad() {
        super.viewDidLoad()
        v.titleLabel.text = "Sign Up"
        
        let bindingInput = SignUpBindingInput(
            username: v.usernameField.rx.text.orEmpty.asDriver(),
            password: v.passwordField.rx.text.orEmpty.asDriver(),
            confirmPassword: v.confirmPasswordField.rx.text.orEmpty.asDriver(),
            goToLogin: v.loginButton.rx.tap.asSignal(),
            signUp: v.signUpButton.rx.tap.asSignal(),
            isLoading: v.loadingIndicator.rx.isAnimating,
            isSignUpButtonEnabled: v.signUpButton.rx.isEnabled,
            usernameMessage: v.usernameMessage,
            passwordMessage: v.passwordMessage,
            confirmPasswordMessage: v.confirmPasswordMessage
        )
        input(bindingInput).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

final class SignUpView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordLabel: UILabel!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var usernameMessage: Binder<FieldMessage?> {
        return Binder(self) { (this, message) in
            this.usernameLabel.text = message?.text
            
            switch message {
            case .info: this.usernameLabel.textColor = UIColor.darkText
            case .error: this.usernameLabel.textColor = UIColor.systemRed
            case .none: break
            }
        }
    }
    
    var passwordMessage: Binder<FieldMessage?> {
        return Binder(self) { (this, message) in
            this.passwordLabel.text = message?.text
            switch message {
            case .info: this.passwordLabel.textColor = UIColor.darkText
            case .error: this.passwordLabel.textColor = UIColor.systemRed
            case .none: break
            }
        }
    }
    
    var confirmPasswordMessage: Binder<FieldMessage?> {
        return Binder(self) { (this, message) in
            this.confirmPasswordLabel.text = message?.text
            switch message {
            case .info: this.confirmPasswordLabel.textColor = UIColor.darkText
            case .error: this.confirmPasswordLabel.textColor = UIColor.systemRed
            case .none: break
            }
        }
    }
}
