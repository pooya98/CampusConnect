//
//  ContentView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/02.
//

/*
import SwiftUI

// OnboardingView 정의
struct OnboardingView: View {
    var body: some View {
        // 수직으로 컨트롤을 정렬
        VStack {
            // Spacer() <- 가능한 많은 공간을 차지하여 이후의 컨트롤을 아래쪽으로 밀어냄
            // Spacer()에 minLength를 설정하여 아래쪽으로 밀리는 정도 조절
            Spacer(minLength: 570)
            
            // "시작하기" 버튼
            // 누르면 SignUpView로 이동
            NavigationLink(destination: SignUpView()) {
                Text("시작하기")
                    .font(.system(size: 20))  // text font size 설정
                    .foregroundColor(.white)  // text color 설정 (white)
                    .frame(width: 350, height: 50)  // 버튼 크기 설정
                    .background(Color.blue)  // 버튼 배경색 설정 (하늘색)
                    .cornerRadius(5.0)  // 버튼 모서리를 둥글게
            }
            .padding(.bottom, 5)  // 버튼 아래 패딩 추가
            
            // "계정이 이미 있어요" 버튼
            // 누르면 일단 콘솔에 메시지를 출력
            // 이 버튼을 눌렀을 때 로그인 화면으로 이동하도록 설정
            Button(action: {
                print("이미 계정이 있음")
            }) {
                Text("계정이 이미 있어요")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(width: 350, height: 50)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)  // 테두리 둥글게
                                .stroke(Color.black, lineWidth: 1))  // 테두리 색상 검은색으로
            }
          Spacer() // 아래쪽으로 밀어내는 Spacer
        }
    }
}

// SignUpView를 정의 부분
// 일단 단순히 텍스트만 표시하도록 작성되었지만,
// 실제로는 이 곳에 회원가입 화면 디자인
struct SignUpView: View {
    var body: some View {
        Text("회원가입 화면")
    }
}
*/

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 570)
                
                NavigationLink(destination: SignUpView()) {
                    Text("시작하기")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 350, height: 50)
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .padding(.bottom, 5)
                
                NavigationLink(destination: LogInView()) {
                    Text("계정이 이미 있어요")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 350, height: 50)
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1))
                }
                Spacer()
            }
        }
    }
}



