//
//  AuthenticationManager.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/03.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager() //instance of the class
    private init() { }
    
   
    // creates a user and automatically logs them in, that is,
    // the authentiction data is locally cached in on the device
    @discardableResult
    func createUser (email: String, password: String) async throws -> AuthDataResultModel { // async since it pings the server and waits for a response
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser (email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    // MARK: - TODO
    
    // get the loccally cached in authetication data
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            //user not signed in
            //TODO: cutomize error message
            throw URLError(.badServerResponse) // auth might not have finished initializing
        }
        
        return AuthDataResultModel(user: user)
    }
    
    /*func reauthenticateUser(credential: AuthCredential) async throws {
        guard let user = Auth.auth().currentUser else {
            //user not signed in
            //TODO: cutomize error message
            throw URLError(.badServerResponse) // auth might not have finished initializing
        }
        try await user.reauthenticate(with: credential)
    }*/
    
    // MARK: - TODO
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            //user not signed in
            //TODO: cutomize error message
            throw URLError(.badServerResponse) // auth might not have finished initializing
        }
        
        try await user.updateEmail(to: email)
    }
    
    // MARK: - TODO
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            //user not signed in
            //TODO: cutomize error message
            throw URLError(.badServerResponse) // auth might not have finished initializing
        }
        
        try await user.updatePassword(to: password)
    }
    
    
    // successful when no error is thrown
    func resetPassword(email: String) async throws {
       try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - TODO
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            //user not signed in
            //TODO: cutomize error message
            throw URLError(.badServerResponse) // auth might not have finished initializing
        }
        
        //deletes and signs out the user
        try await user.delete()
    }
}
