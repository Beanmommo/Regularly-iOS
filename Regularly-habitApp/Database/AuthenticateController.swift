//
//  AuthenticateController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 10/5/2023.
//

import Foundation
import FirebaseAuth
import FirebaseCore

// Database for user authentication
class AuthenticateController: NSObject, AuthenticateProtocol{
    var signInUserId: String
    var authController: Auth
    
    override init() {
        FirebaseApp.configure()
        self.authController = Auth.auth()
        self.signInUserId = ""
        
    }
    
    @MainActor
    func loginAccount(email: String, pass: String) async throws{
        //Called when the user pressed login
        do {
            let authDataResult = try await authController.signIn(withEmail: email, password: pass)
            self.signInUserId = authDataResult.user.uid
            
        }catch{
            print("There was an issue trying to sign in: \(error)")
        }
        
    }
    //addStateDiChangeListener
    @MainActor
    func createAccount(email: String, pass: String) async throws -> String{
        //Called when the user pressed create account button
        var userUID = ""
        do{
            let authDataResult = try await authController.createUser(withEmail: email, password: pass)
            userUID = authDataResult.user.uid
        }catch{
            print("There was an issue trying to create-account: \(error)")
        }
        return userUID
        
    }
    
    @MainActor
    func signOut() async throws{
        do {
            let _ = try authController.signOut()
            self.signInUserId = ""
        }catch{
            print("Error signing out: \(error)")
        }
    }
    
    func getSignedInUserUUID() -> String {
        guard let uid = authController.currentUser?.uid else{
            return ""
        }
        return uid
    }
}
