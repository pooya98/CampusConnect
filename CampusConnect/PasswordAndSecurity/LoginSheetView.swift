//
//  LoginSheetView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/07.
//

import SwiftUI


@MainActor
final class LoginSheetViewModel: ObservableObject {
    
    @Published var password = ""
    @Published var PasswordNotFilled = false
    

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



struct LoginSheetView: View {
   
    @StateObject private var loginSheetViewModel = LoginSheetViewModel()
    @State private var reauthenticationError = ""
    @State private var showReauthErrorAlert = false
    @Binding var showLoginSheet: Bool
    @Binding var showChangePassSheet: Bool
    

    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            Button {
                // dismiss LoginSheetView
                showLoginSheet = false
            } label: {
                Text("Cancel")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .padding()
            
            
            VStack {
                
                Text("Enter Login Password")
                    .font(.title3)
                
                TextField("Password", text: $loginSheetViewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                if loginSheetViewModel.PasswordNotFilled {
                    Text("Password must be filled")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Button {
                    Task{
                        do {
                            
                            let reauthSuccess = try await loginSheetViewModel.reauthenticateUser()
                            
                            if reauthSuccess {
                                // dismiss LoginSheetView
                                showLoginSheet = false
                                
                                // display ChangePassSheet
                                showChangePassSheet = true
                            }
                            
                        } catch {
                            showReauthErrorAlert = true
                            // TODO: cutomize reauth error
                            print("Reauthentication Error: \(error)")
                            reauthenticationError = error.localizedDescription
                            
                        }
                    }
                    
                } label: {
                    Text("OK")
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
                    Text(reauthenticationError)
                        .fontWeight(.medium)
                }
                
            }
            .padding()
            .frame(maxHeight: .infinity)
            
            
        }
        
    }
    
}

struct LoginSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSheetView(showLoginSheet: .constant(false), showChangePassSheet: .constant(false))
    }
}

