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

class AuthenticationManager {
    
    static let shared = AuthenticationManager() //instance of the class
    private init() { }
    
    
    func createUser (email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            //TODO: cutomize error message
            throw URLError(.badServerResponse) // auth might not have finished initializing
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
