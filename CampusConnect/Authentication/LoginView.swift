//
//  LoginView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/03.
//

import SwiftUI

@MainActor // concurrency
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var EmailPasswordNotFilled = false
    
    // returns true on successful login
    func loginUser() async throws -> Bool {
        guard email.isEmpty == false, password.isEmpty == false else {
            EmailPasswordNotFilled = true
            print("No email or password found.")
            return false
        }
        
        EmailPasswordNotFilled = false
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
        return true
    }
}

struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    @Binding var showLoginView: Bool
    @State private var loginErrorAlert = false
    @State private var loginErrorMessage = ""
    
    var body: some View {
        VStack{
            
            TextField("Email", text: $loginViewModel.email)
                .padding()
                .autocapitalization(.none)
                .textCase(.lowercase)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password", text: $loginViewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if(loginViewModel.EmailPasswordNotFilled){
                Text("Fill in both email and password")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            // MARK: - TODO
            // TODO: Add loading spinner
            Button {
                Task{
                    do {
                        //print("show login view1: \(showLoginView)")
                        let loginSuccess = try await loginViewModel.loginUser()
                        //print("show login view2: \(showLoginView)")
                        
                        if loginSuccess {
                            showLoginView = false
                            //print("show login view3: \(showLoginView)")
                        }
                    
                    } catch {
                        loginErrorAlert = true
                        
                        // TODO: cutomize login error
                        print("show login view4: \(showLoginView)")
                        print("Login Error: \(error)")
                        loginErrorMessage = error.localizedDescription
                       
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
            
            // MARK: - Login Failed Alert
            .alert("Login Failed", isPresented: $loginErrorAlert) {
                // Add buttons like OK, CANCEL here
            } message: {
                Text(loginErrorMessage)
                    .fontWeight(.medium)
            }
            
            /*Spacer()
            
            Divider()
                .padding()
            
            Spacer()*/
            
            // MARK: - TODO
            
            //TODO: login with apple id
            
            HStack{
                NavigationLink{
                    CreateAccountView()
                } label: {
                    Text("Create Account")
                }
                
                Spacer()
                
                NavigationLink{
                    ResetPasswordView()
                } label: {
                    Text("Forgot Password?")
                }
            }
            .padding(.top)
            
            /*NavigationLink{
                CreateAccountView()
            } label: {
                Text("Create Account")
            }*/
            
        }
        .padding()
        .navigationTitle("Login")
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView(showLoginView: .constant(false))
        }
    }
}

// MARK: - ISSUE

// TODO: fix bug - Textfields don't clear when user enters values then moves to the create account view and comes back to login view
