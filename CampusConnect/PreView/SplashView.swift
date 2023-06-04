//
//  SplashView.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/05/30.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var remainingSeconds = 5  // 5초 카운트다운

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()  // 매 초마다 트리거 되는 타이머

    var body: some View {
        VStack {
            if remainingSeconds > 0 {  // 1보다 클 때만 카운트다운 텍스트를 표시
                Text("\(remainingSeconds)")
                    .padding()
            }
            
            Spacer()  // Text 아래에 Spacer 추가하여 Text를 상단으로 이동

            if isActive {
                OnboardingView()
            } else {
                Text("Splash 화면")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                    .onReceive(timer) { _ in  // 타이머로부터의 입력을 받음
                        if self.remainingSeconds > 0 {
                            self.remainingSeconds -= 1
                        }
                        if self.remainingSeconds == 0 {  // 0이 되면 isActive를 true로 설정하여 OnboardingView로 전환
                            self.isActive = true
                        }
                    }
            }
        }
    }
}
