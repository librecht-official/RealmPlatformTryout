//
//  API.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 23/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift


protocol LoginAPI {
    func loginAsGuest() -> Single<User>
    func isUserGuest() -> Bool
    
    func login(username: String, password: String, register: Bool) -> Single<User>
    func logout()
    func loggedInUser() -> User?
}

extension PublicRealmAPIClient: LoginAPI {
    func loginAsGuest() -> Single<User> {
        return login(username: "Guest", password: "guest", register: false)
            .do(onSuccess: { user in
                AppPersistence.setUserIsGuest(true)
            })
    }
    
    func isUserGuest() -> Bool {
        return AppPersistence.isUserGuest()
    }
    
    func login(username: String, password: String, register: Bool) -> Single<User> {
        let config = self.configuration
        
        return Single.create { push -> Disposable in
            if let current = SyncUser.current {
                current.logOut()
            }
            let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register)
            SyncUser.logIn(with: creds, server: config.authURL) { (user, error) in
                if let user = user {
                    let config = user.configuration(
                        realmURL: config.publicRealmURL,
                        fullSynchronization: true
                    )
                    Realm.asyncOpen(configuration: config, callbackQueue: .main) { (_, error) in
                        if let error = error {
                            print("Realm.asyncOpen error: \(error)")
                            push(.error(error))
                        } else {
                            push(.success(User(syncUser: user)))
                        }
                    }
                } else if let error = error {
                    print(error)
                    push(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func logout() {
        if let current = SyncUser.current {
            current.logOut()
        }
    }
    
    func loggedInUser() -> User? {
        return SyncUser.current.map { User(syncUser: $0) }
    }
    
    private func configurePublicRealm() {
        let creds = SyncCredentials.usernamePassword(username: "admin", password: "admin", register: false)
        SyncUser.logIn(with: creds, server: configuration.authURL) { (user, error) in
            guard let user = user else {
                print(error!)
                return
            }
            let permission = SyncPermission(realmPath: "/public", identity: "*", accessLevel: .write)
            user.apply(permission) { error in
                if let error = error{
                    print(error)
                } else {
                    user.retrievePermissions { permissions, error in
                        if let error = error {
                            print("error getting permissions \(error)")
                        } else {
                            print("public realm configured")
                        }
                    }
                }
            }
        }
    }
}
