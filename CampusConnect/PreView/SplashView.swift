//
//  SplashView.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/05/30.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var remainingSeconds = 2  // 몇 초 할지
    @EnvironmentObject var ownerview : OwnerView

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()  // 매 초마다 트리거 되는 타이머

    var body: some View {
        ZStack {  // ZStack을 사용하여 배경색과 이미지를 동시에 설정
            Color.black  // 배경색을 검정색으로 설정
                .ignoresSafeArea()  // safe area를 무시하여 전체 화면을 채움

            // SplashName라는 이미지를 추가. 이 부분을 실제 이미지 이름으로 바꾸세요.
            Image("SplashName")
                .resizable()  // 이미지 크기 조절을 가능하게 함
                .aspectRatio(contentMode: .fit)  // 이미지를 원본 비율로 맞춤
                .frame(width: 200, height: 200)  // 이미지의 크기를 설정
            
            VStack {
                Spacer()  // Text 아래에 Spacer 추가하여 Text를 상단으로 이동

                if isActive {
                    //OnboardingView()
                } else {
                    EmptyView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation {
                                    //self.isActive = true
                                }
                            }
                        }
                        .onReceive(timer) { _ in  // 타이머로부터의 입력을 받음
                            if self.remainingSeconds > 0 {
                                self.remainingSeconds -= 1
                            }
                            if self.remainingSeconds == 0 {  // 0이 되면 isActive를 true로 설정하여 OnboardingView로 전환
                                //self.isActive = true
                                ownerview.owner = .onboardingview
                            }
                        }
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
