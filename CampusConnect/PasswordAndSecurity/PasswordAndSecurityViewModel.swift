//
//  PasswordAndSecurityViewModel.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/07.
//

import Foundation

@MainActor
final class PasswordAndSecurityViewModel: ObservableObject {
    
    @Published var password = ""
    //@Published var newPassword = ""
    //@Published var verifyPassword = ""
    @Published var PasswordNotFilled = false
    
    // get values from user
    /*func updatePassword () async throws {
        try await AuthenticationManager.shared.updatePassword(password: newPassword)
    }*/
    
    
    // TODO: review reauthenticateUser()
    func reauthenticateUser() async throws -> Bool {
        
        guard password.isEmpty == false else {
            PasswordNotFilled = true
            print("Reauthentication password not provided.")
            return false
        }
        PasswordNotFilled = false
        
        guard let authenticatedUser =  try? AuthenticationManager.shared.getAuthenticatedUser() else {
            print("Reauthentication failed. User not logged In")
            return false
        }
        
        //
        guard let email = authenticatedUser.email else {
            print("Email not found. User is anonymous")
            return false
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        return true
    }
    
}
