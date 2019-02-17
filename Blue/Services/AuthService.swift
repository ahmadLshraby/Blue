//
//  AuthService.swift
//  Blue
//
//  Created by sHiKoOo on 2/17/19.
//  Copyright © 2019 sHiKoOo. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let result = result {
                let userData = ["proviser": result.user.providerID,
                                "email": result.user.email!]
                DataService.instance.createDBUser(uid: result.user.uid, userData: userData)
                userCreationComplete(true, nil)
            }else {
                userCreationComplete(false, error)
                return
            }

        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping(_ status: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, link: password) { (result, error) in
            if let result = result {
                loginComplete(true, nil)
            }else {
                loginComplete(false, error)
                return
            }
        }
    }
    
}
