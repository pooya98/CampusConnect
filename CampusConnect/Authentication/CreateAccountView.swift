//
//  CreateAccountView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/03.
//

import SwiftUI


struct CreateAccountView: View {
    
    @StateObject var createAccountViewModel = CreateAccountViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showAccountCreatedAlert = false
    @State private var showCreateAccountError = false
    @State private var createAccountErrorMsg = ""
    
    var body: some View {
        VStack{
            
            TextField("First Name", text: $createAccountViewModel.firstName)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if(createAccountViewModel.firstNameNotfilled){
                Text("First Name Required")
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            TextField("Last Name", text: $createAccountViewModel.lastName)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if(createAccountViewModel.lastNameNotfilled){
                Text("Last Name Required")
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            TextField("Email", text: $createAccountViewModel.email)
                //.autocapitalization(.none)
                //.textCase(.lowercase)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if(createAccountViewModel.isInvalidEmail){
                Text("Invalid email address")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            SecureField("Password", text: $createAccountViewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if(createAccountViewModel.isInvalidPassword){
                Text("Your password must be at least 8 characters, include and a number, lowercase letter, uppercase letter and a special character")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            /*SecureField("Confirm Password", text: $createAccountViewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)*/
            
            Button {
                Task {
                    do{
                        let createAccountSuccess = try await createAccountViewModel.createAccount()
                        
                        if createAccountSuccess {
                            // dismiss current view
                            dismiss()
                            showAccountCreatedAlert = true
                        }
                        
                    }catch{
                        showCreateAccountError = true
                        print("Create Account Error: \(error)")
                        createAccountErrorMsg = error.localizedDescription
                    }
                }
            } label: {
                Text("Create Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            // MARK: - Created Alert
            
            .alert("Account Created", isPresented: $showAccountCreatedAlert){
                // Add buttons like OK, CANCEL here
            } message: {
                Text("You can now login.")
                    .fontWeight(.medium)
            }
            
            // MARK: - Failed Alert
            .alert("Account Creation Failed", isPresented: $showCreateAccountError) {
                
            } message: {
                Text(createAccountErrorMsg)
                    .fontWeight(.medium)
            }
            
        }
        .padding()
        .navigationTitle("Create Account")
    }
    
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateAccountView()
        }
        
    }
}
