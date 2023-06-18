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
        VStack(alignment: .leading){
            
            Group{
                Text("이름")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
                CustomTextField1(text: $createAccountViewModel.firstName)
                
                if(createAccountViewModel.firstNameNotfilled){
                    Text("First Name Required")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Text("성")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
                CustomTextField1(text: $createAccountViewModel.lastName)
                
                
                if(createAccountViewModel.lastNameNotfilled){
                    Text("Last Name Required")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Text("이메일")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                
                CustomTextField1(text: $createAccountViewModel.email)
                
                if(createAccountViewModel.isInvalidEmail){
                    Text("Invalid email address")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
            }
            
            Text("비밀번호")
                .font(.caption)
                .foregroundColor(Color.gray)
            
            CustomSecureField(text: $createAccountViewModel.password)
            
            Text("비밀번호 확인")
                .font(.caption)
                .foregroundColor(Color.gray)
            
            CustomSecureField(text: $createAccountViewModel.reEnteredPassword)
            
            Group{
                
                if(createAccountViewModel.passwordNotFilled) {
                    Text("Enter password")
                }
                
                if(createAccountViewModel.isInvalidPassword){
                    Text("Your password must be at least 8 characters, include and a number, lowercase letter, uppercase letter and a special character")
                }
                
                if(createAccountViewModel.passwordsDontMatch) {
                    Text("Password and re-entered password must match")
                }
            }
            .foregroundColor(.red)
            .font(.footnote)
            
            
            Button {
                Task {
                    do{
                        let createAccountSuccess = try await createAccountViewModel.createAccount()
                        
                        if createAccountSuccess {
                            // dispaly success alert
                            showAccountCreatedAlert = true
                        }
                        
                    }catch{
                        showCreateAccountError = true
                        print("Create Account Error: \(error)")
                        createAccountErrorMsg = error.localizedDescription
                    }
                }
            } label: {
                Text("회원가입") // 버튼 텍스트
                    .font(.headline) // 텍스트 크기 조정
                    .foregroundColor(.white) // 텍스트 색상 설정
                    .frame(width: 350, height: 50) // 버튼 크기 설정
                    .background(Color(red: 247/255, green: 202/255, blue: 246/255)) // 배경색 설정
                    .cornerRadius(10.0)
            }
            .padding(.top, 20)
            
            // MARK: - Account Created Alert
            
            .alert("Account Created", isPresented: $showAccountCreatedAlert){
                // Add buttons like OK, CANCEL here
                Button("OK",role: .cancel) {
                    // dismiss current view
                    dismiss()
                }
            } message: {
                Text("You can now login.")
                    .fontWeight(.medium)
            }
            
            // MARK: - Creation Failed Alert
            .alert("Account Creation Failed", isPresented: $showCreateAccountError) {
                
            } message: {
                Text(createAccountErrorMsg)
                    .fontWeight(.medium)
            }
        }
        .padding()
        
    }
}

struct CustomTextField1: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("", text: $text) // 빈 텍스트 필드, text 바인딩
                .padding(.vertical, 0) // 수직(padding) 방향으로 음수 마진 적용하여 필드 내부 공간 조정
                .foregroundColor(Color(red: 90/255, green: 90/255, blue: 90/255)) // 텍스트 색상 설정

            Divider() // 구분선
                .background(Color.gray) // 배경색 설정
        }
    }
}

struct CustomSecureField: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SecureField("", text: $text) // 빈 텍스트 필드, text 바인딩
                .padding(.vertical, 0) // 수직(padding) 방향으로 음수 마진 적용하여 필드 내부 공간 조정
                .foregroundColor(Color(red: 90/255, green: 90/255, blue: 90/255)) // 텍스트 색상 설정

            Divider() // 구분선
                .background(Color.gray) // 배경색 설정
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateAccountView()
        }
        
    }
}
