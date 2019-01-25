//
//  AuthService.swift
//  LibraryX
//
//  Created by Sean Saoirse on 22/01/19.
//  Copyright © 2019 Sean Saoirse. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    static let instance = AuthService()
    
    func registerUser(email: String, password: String, fullName: String, userCreationComplete: @escaping (_ status: Bool,_ error: Error?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            
            guard let authData = authData else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["email": authData.user.email, "fullName": fullName, "uid": Auth.auth().currentUser?.uid,"library": "none"]
            
            DataService.instance.createDBUser(uid: authData.user.uid, userData: userData)
            userCreationComplete(true, nil)
            
        }
    }
    
    func loginUser(email: String, password: String, loginComplete: @escaping(_ status: Bool,_ error: Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                loginComplete(false, error)
                return
            }
            
            loginComplete(true, nil)
        }
    }
}
