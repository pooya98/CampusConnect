//
//  LoginView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/03.
//

import SwiftUI


final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}

struct LoginView: View {
    
    @StateObject var login = LoginViewModel()
    
    var body: some View {
        VStack{
            
            TextField("Email", text: $login.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            TextField("Password", text: $login.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                
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
        LoginView()
    }
}
