//
//  EmailReauthView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/10.
//

import SwiftUI

@MainActor
final class EmailReauthViewModel: ObservableObject {
    @Published var password = ""
    @Published var PasswordNotFilled = false
    @Published var userId = ""
    
    
    func reauthUser() async throws -> Bool {
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
        
        userId = authenticatedUser.uid
        
        guard let email = authenticatedUser.email else {
            print("Email not found. User is anonymous")
            return false
        }
        
        // Reauth user by logging in
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        return true
    }
    
    // Delete auth data
    func deleteAccount() async throws {
        
        guard let _ = try? await  AuthenticationManager.shared.deleteUser() else {
            print("Account Deletion failed. Login required")
            return
        }
        
        print("Account Deleted")
        
    }
    
    
    // Delete data from firestore
    func deleteAccountData() async throws {
        guard let _ = try? await UserManager.shared.deleteUserData(userId: userId) else {
            print("Account Data Deletion failed due to an Error")
            return
        }
        
        print("Account Data deleted")
        
    }
    
}

struct EmailReauthView: View {
    
    @StateObject private var emailReauthViewModel = EmailReauthViewModel()
    @State private var reauthError = ""
    @State private var showReauthErrorAlert = false
    @Binding var showReauthSheet : Bool
    
    var body: some View {
       
        ZStack(alignment: .topLeading) {
            
            Button {
                // Dismiss EmailReauthView
                showReauthSheet = false
            } label: {
                Text("Cancel")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .padding()
            
            
            VStack {
                
                Text("Enter Login Password")
                    .font(.title3)
                
                SecureField("Password", text: $emailReauthViewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                if emailReauthViewModel.PasswordNotFilled {
                    Text("Password must be filled")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Button {
                    Task{
                        do {
                            
                            let reauthSuccess = try await emailReauthViewModel.reauthUser()
                            
                            if reauthSuccess {
                                // Dismiss EmailReauthView
                                showReauthSheet = false
                                
                                // User reauthenticated
                                // Delete account
                                try await emailReauthViewModel.deleteAccount()
                                
                                // Delete account data
                                try await emailReauthViewModel.deleteAccountData()
                                
                                print("Logged out")
                                
                                // Display login screen
                                //showLoginView = true
                            }
                            
                        } catch {
                            showReauthErrorAlert = true
                            // TODO: cutomize reauth error
                            print("Reauthentication Error: \(error)")
                            reauthError = error.localizedDescription
                            
                        }
                    }
                    
                } label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                // MARK: - Reauth Error Alert
                .alert("Reauthenication Failed",isPresented: $showReauthErrorAlert) {
                    // Add buttons like OK, CANCEL here
                } message: {
                    Text(reauthError)
                        .fontWeight(.medium)
                }
                
            }
            .padding()
            .frame(maxHeight: .infinity)
            
            
        }
    }
}

struct EmailReauthView_Previews: PreviewProvider {
    static var previews: some View {
        EmailReauthView(showReauthSheet: .constant(false))
    }
}
