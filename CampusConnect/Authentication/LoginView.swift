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
    
    
    func loginUser() async throws{
        guard email.isEmpty == false, password.isEmpty == false else {
            EmailPasswordNotFilled = true
            print("No email or password found.")
            return
        }
        
        EmailPasswordNotFilled = false
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    @Binding var showLoginView: Bool
    
    var body: some View {
        VStack{
            
            TextField("Email", text: $loginViewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            TextField("Password", text: $loginViewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if(loginViewModel.EmailPasswordNotFilled){
                Text("Fill in both email and password")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button {
                Task{
                    do {
                        try await loginViewModel.loginUser()
                        showLoginView = false
                    }catch {
                        print(error)
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
            
//                Spacer()
//
//                Divider()
//                    .padding()
//
//                Spacer()
            
            //TODO: login with apple id
            
            NavigationLink{
                CreateAccountView()
            } label: {
                Text("Create Account")
            }
            
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
