//
//  SignUp.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

enum SignUp {
    struct State {
        var username: String
        var password: String
        var confirmPassword: String
        var usernameMessage = usernamePlaceholder()
        var passwordMessage = passwordPlaceholder()
        var confirmPasswordMessage = password2Placeholder()
        
        var isLoading: Bool = false
        
        var signUpRequest: SignUpRequest? = nil
        var navigationRequest: LoginRoute? = nil
        
        var isSignUpEnabled: Bool {
            let result = Auth.validate(
                username: username,
                password: password
            )
            return !isLoading && password == confirmPassword && result.isValid
        }
    }
    
    enum Command {
        case updateUsername(String)
        case updatePassword(String)
        case updateConfirmPassword(String)
        
        case signUp
        case didSignUp(User)
        case didFailSignUp(Error)
        
        case goToLogin
        case didNavigateTo(LoginRoute)
    }
    
    static let initialState = State(
        username: "",
        password: "",
        confirmPassword: ""
    )
    
    static func reduce(state: State, command: Command) -> State {
        var newState = state
        switch command {
        case let .updateUsername(username):
            newState.username = username
            newState = validation(state: newState)
            
        case let .updatePassword(password):
            newState.password = password
            newState = validation(state: newState)
            
        case let .updateConfirmPassword(password):
            newState.confirmPassword = password
            newState = validation(state: newState)
            
        case .signUp:
            newState = signUp(state: state)
        case let .didSignUp(user):
            newState.signUpRequest = nil
            newState.isLoading = false
            newState.navigationRequest = .main(user)
        case .didFailSignUp:
            newState.signUpRequest = nil
            newState.isLoading = false
            
        case .goToLogin:
            newState.navigationRequest = .login
        case .didNavigateTo:
            newState.navigationRequest = nil
        }
        return newState
    }
    
    // MARK: UseCases
    
    static func validation(state: State) -> State {
        var newState = state
        let valid = Auth.validate(
            username: state.username,
            password: state.password
        )
        if newState.username.isEmpty == false {
            newState.usernameMessage = valid.usr ?
                usernamePlaceholder() : .error("Username cannot be empty")
        }
        if newState.password.isEmpty == false {
            newState.passwordMessage = {
                switch valid.pwd {
                case .weak: return .info("Weak password")
                case .normal: return .info("Normal password")
                case .strong: return .info("Strong password")
                case let .failed(rules):
                    return .error(rules.map { "\($0)" }.joined(separator: ", "))
                }
            }()
        }
        if newState.confirmPassword.isEmpty == false {
            let passwordsMatch = newState.password == newState.confirmPassword
            newState.confirmPasswordMessage = passwordsMatch ?
                password2Placeholder() : .error("Passwords does not match")
        }
        return newState
    }
    
    static func signUp(state: State) -> State {
        var newState = state
        if newState.isSignUpEnabled {
            newState.signUpRequest = SignUpRequest(
                username: newState.username,
                password: newState.password
            )
            newState.isLoading = true
        }
        return newState
    }
    
    // MARK: Structures
    
    struct SignUpRequest: Equatable {
        let username: String
        let password: String
    }
}

private func usernamePlaceholder() -> FieldMessage {
    return .info("Username")
}

private func passwordPlaceholder() -> FieldMessage {
    return .info("Password")
}

private func password2Placeholder() -> FieldMessage {
    return .info("Confirm Password")
}
