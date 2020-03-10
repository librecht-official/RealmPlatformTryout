//
//  AppOnboardingFinish.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 10.03.2020.
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


enum AppOnboardingFinish {
    struct State {
        var title: String = "We are almost done"
        var descriptionText: String = "Synchronizing your Realm with Cloud so you could use it offline later. It may take some time."
        
        var continueButtonTitle: String = "Finishing..."
        var continueButtonEnabled: Bool = false
        var continueButtonHidden: Bool = false
        var continueButtonActivityIndicator: Bool = true
        
        let retryButtonTitle: String = "Retry"
        var retryButtonHidden: Bool = true
        
        var errorMessage: String? = nil
        
        var effectRequest: Feedback.Request<Effect>? = .init(.loginAsGuest)
        
        fileprivate var loggedInUser: User? = nil
    }
    
    enum Command {
        case `continue`
        case retry
        case didLogin(Result<User, Error>)
    }
    
    enum Effect: Equatable {
        case loginAsGuest
        case navigateToMain(User)
    }
    
    static func reduce(state: State, command: Command) -> State {
        var state = state
        switch command {
        case .continue:
            if let user = state.loggedInUser {
                state.effectRequest = .init(.navigateToMain(user))
            }
            
        case .retry:
            state.continueButtonActivityIndicator = true
            state.effectRequest = .init(.loginAsGuest)
            
        case let .didLogin(result):
            switch result {
            case let .success(user):
                state.title = "Done"
                state.descriptionText = "You are ready to go!"
                
                state.continueButtonTitle = "Continue"
                state.continueButtonEnabled = true
                state.continueButtonHidden = false
                state.continueButtonActivityIndicator = false
                state.retryButtonHidden = true
                
                state.errorMessage = nil
                state.loggedInUser = user
                
            case .failure:
                state.errorMessage = "Couldn't connect to realm server. Most likely the trial period has ended."
                state.continueButtonHidden = true
                state.continueButtonActivityIndicator = false
                state.retryButtonHidden = false
            }
        }
        return state
    }
}
