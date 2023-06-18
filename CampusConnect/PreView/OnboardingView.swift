//
//  ContentView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/02.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var ownerview: OwnerView

    var body: some View {
        NavigationView {
            VStack {
                Spacer(minLength: 0)

                TabView(selection: $selectedTab) {
                    ForEach(0..<3) { index in
                        Image("feature\(index + 1)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)  // 이미지 높이 조절
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())

                // Custom page indicator
                HStack {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(selectedTab == index ? Color(red: 247/255, green: 202/255, blue: 246/255) : Color(red: 229/255, green: 229/255, blue: 229/255))
                            .frame(width: 7, height: 7)  // 원의 크기 조절
                            .padding(.horizontal, 1)
                    }
                }
                .padding(.top, -150)

                Spacer(minLength: 0) // Adjust this value to move the buttons
                
                Text("시작하기")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 350, height: 50)
                    .background(Color(red: 247/255, green: 202/255, blue: 246/255))
                    .cornerRadius(5.0)
                    .onTapGesture {
                        ownerview.owner = .signinview
                    }
                
                
                
                Spacer()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}



