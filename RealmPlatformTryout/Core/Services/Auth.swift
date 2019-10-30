//
//  Auth.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 26/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation


enum Auth {
    struct CredsValidationResult {
        let usr: Bool
        let pwd: PasswordValidationResult
        
        var isValid: Bool {
            let pwdValid: Bool
            switch pwd {
            case .weak, .normal, .strong:
                pwdValid = true
            case .failed:
                pwdValid = false
            }
            return usr && pwdValid
        }
    }
    static func validate(username: String, password: String) -> CredsValidationResult {
        return CredsValidationResult(
            usr: validate(username: username),
            pwd: validate(password: password)
        )
    }
    
    // MARK: Username
    
    static func validate(username: String) -> Bool {
        return !username.isEmpty
    }
    
    // MARK: Password
    
    enum PasswordValidationResult {
        case strong
        case normal
        case weak
        case failed(rules: [PasswordValidationRule])
    }
    enum PasswordValidationRule {
        // Password should contain:
        case onlyAlphanumerics
        case atLeastLength(Int)
        case atLeastDigits(Int)
        case atLeastLetters(Int)
        case atLeastUppercaseLetters(Int)
    }
    static func validate(password: String) -> PasswordValidationResult {
        var failedRules = [PasswordValidationRule]()
        
        if password.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            failedRules.append(.onlyAlphanumerics)
        }
        if password.count < 4 {
            failedRules.append(.atLeastLength(4))
        }
        if password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
            failedRules.append(.atLeastUppercaseLetters(1))
        }
        if password.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            failedRules.append(.atLeastDigits(1))
        }
        if password.rangeOfCharacter(from: CharacterSet.letters) == nil {
            failedRules.append(.atLeastLetters(1))
        }
        guard failedRules.isEmpty else {
            return .failed(rules: failedRules)
        }
        if password.count >= 8 {
            return .strong
        }
        if password.count >= 6 {
            return .normal
        }
        return .weak
    }
}
