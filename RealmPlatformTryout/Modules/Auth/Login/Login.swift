//
//  Login.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 25/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

enum Login {
    struct State {
        var username: String
        var password: String
        
        var loginRequest: LoginRequest? = nil
        var navigationRequest: LoginRoute? = nil
        
        var isLoading: Bool = false
        
        var isLoginEnabled: Bool {
            return !isLoading && !username.isEmpty && !password.isEmpty
        }
    }
    
    enum Command {
        case updateUsername(String)
        case updatePassword(String)
        
        case login
        case didLogin(User)
        case didFailLogin(Error)
        
        case goToSignUp
        case didNavigateTo(LoginRoute)
    }
    
    static let initialState = State(
        username: "",
        password: ""
    )
    
    static func reduce(state: State, command: Command) -> State {
        var newState = state
        switch command {
        case let .updateUsername(username):
            newState.username = username
            
        case let .updatePassword(password):
            newState.password = password
            
        case .login:
            newState = login(state: state)
            
        case let .didLogin(user):
            newState.loginRequest = nil
            newState.isLoading = false
            newState.navigationRequest = .main(user)
            
        case .didFailLogin:
            newState.loginRequest = nil
            newState.isLoading = false
            
        case .goToSignUp:
            newState.navigationRequest = .signUp
            
        case .didNavigateTo:
            newState.navigationRequest = nil
        }
        return newState
    }
    
    // MARK: UseCases
    
    static func login(state: State) -> State {
        var newState = state
        if newState.isLoginEnabled {
            newState.loginRequest = LoginRequest(
                username: newState.username,
                password: newState.password
            )
            newState.isLoading = true
        }
        return newState
    }
    
    struct LoginRequest: Equatable {
        let username: String
        let password: String
    }
}
