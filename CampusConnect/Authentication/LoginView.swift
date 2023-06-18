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
    
    @State private var loginErrorAlert = false
    @State private var loginErrorMessage = ""
    @State private var showingPreview = true
    
    @EnvironmentObject var ownerview: OwnerView
    
    var body: some View {
        NavigationView {
            VStack{
                
                TextField("Email", text: $loginViewModel.email)
                    .padding()
                    .border(Color.gray, width: 0.5)
                
                SecureField("Password", text: $loginViewModel.password)
                    .padding()
                    .border(Color.gray, width: 0.5)
                
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
                                //showLoginView = false
                                //print("show login view3: \(showLoginView)")
                                ownerview.owner = .mainview
                            }
                            
                        } catch {
                            loginErrorAlert = true
                            
                            // TODO: cutomize login error
                            print("Login Error: \(error)")
                            loginErrorMessage = error.localizedDescription
                            
                        }
                    }
                    
                } label: {
                    Text("로그인") // 로그인 버튼
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 350, height: 50)
                        .background(Color(red: 247/255, green: 202/255, blue: 246/255)) // 배경색 설정
                        .cornerRadius(10.0)
                }
                .padding(.top, 20)
                
                // MARK: - Login Failed Alert
                .alert("Login Failed", isPresented: $loginErrorAlert) {
                    // Add buttons like OK, CANCEL here
                } message: {
                    Text(loginErrorMessage)
                        .fontWeight(.medium)
                }
                
                
                // MARK: - TODO
                
                //TODO: login with apple id
                
                HStack{
                    NavigationLink{
                        CreateAccountView()
                    } label: {
                        Text("Create Account")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    NavigationLink{
                        ResetPasswordView()
                    } label: {
                        Text("Forgot Password?")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// MARK: - ISSUE

// TODO: fix bug - Textfields don't clear when user enters values then moves to the create account view and comes back to login view

