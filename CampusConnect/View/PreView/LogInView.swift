//
//  LogInView.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/05/30.
//

// 오류 발생 코드
// 해결 방법 모르겠음

import SwiftUI

struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false

    var body: some View {
        VStack {
            TextField("이메일", text: $email)
                .padding()
                .border(Color.gray, width: 0.5)
            
            SecureField("패스워드", text: $password)
                .padding()
                .border(Color.gray, width: 0.5)
            
            Button(action:{
                print("Login 버튼 눌림")
                // 로그인 검증 로직
                if email == "123@" && password == "123" {
                    isLoggedIn = true
                } else {
                    isLoggedIn = false
                }
            }) {
                Text("Login")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 350, height: 50)
                    .background(Color.blue)
                    .cornerRadius(5.0)
            }
            
            Spacer().frame(height: 20)  // 버튼과 링크 사이에 간격 추가
            
            NavigationLink(
                destination: HomeView2(),
                isActive: $isLoggedIn,
                label: { EmptyView() }
            )
            .hidden()
          
          
            NavigationLink(destination: ForgotPasswordView()) {
                Text("비밀번호를 잊으셨나요?")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

