//
//  SignUpView.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/05/30.
//

import SwiftUI

struct SignUpView: View {
  @State private var email = ""
  @State private var password = ""
  @State private var confirmPassword = ""
  @State private var showingAlert = false
  @State private var isSignUpSuccessful = false // 회원가입 성공 여부를 나타내는 상태 변수
  
  var body: some View {
    VStack {
      TextField("이메일", text: $email)
        .padding()
        .border(Color.gray, width: 0.5)
      
      SecureField("패스워드", text: $password)
        .padding()
        .border(Color.gray, width: 0.5)
      
      SecureField("패스워드 확인", text: $confirmPassword)
        .padding()
        .border(Color.gray, width: 0.5)
      
      Button(action: {
        if password == confirmPassword {
          print("Sign Up 버튼 눌림")
          // 회원가입 로직 구현
          // 회원가입 성공시
          isSignUpSuccessful = true
        } else {
          showingAlert = true
        }
      }) {
        Text("Sign Up")
          .font(.system(size: 20))
          .foregroundColor(.white)
          .frame(width: 350, height: 50)
          .background(Color.blue)
          .cornerRadius(5.0)
      }
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("비밀번호 불일치"), message: Text("입력한 비밀번호가 일치하지 않습니다. 다시 확인해주세요."), dismissButton: .default(Text("확인")))
      }
      .fullScreenCover(isPresented: $isSignUpSuccessful) {
        HomeView()
      }
    }
    .padding()
  }
}
