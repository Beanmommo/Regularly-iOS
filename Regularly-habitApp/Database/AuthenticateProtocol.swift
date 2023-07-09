//
//  AuthenticateProtocol.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 10/5/2023.
//

import Foundation

protocol AuthenticateProtocol: AnyObject {
    var signInUserId: String { get }
    func createAccount(email: String, pass: String) async throws -> String
    func loginAccount(email: String, pass: String) async throws
    func signOut() async throws
    
}
