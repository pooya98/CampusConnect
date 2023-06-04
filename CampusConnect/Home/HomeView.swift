//
//  HomeView.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/05/30.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingSearchView = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: SearchView(), isActive: $isShowingSearchView) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .isDetailLink(false) // 페이지 전환 설정
                    Image(systemName: "bell")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)

                StoriesView()
                    .frame(height: 100)
                    //.padding(.horizontal, 8)

                Spacer()
            }
            .navigationBarBackButtonHidden(false) // Back 버튼 숨기기
            .navigationBarHidden(true) // 네비게이션 바 숨기기
        }
    }
}


struct StoriesView: View {
  let stories: [String] = ["스토리 1", "스토리 2", "스토리 3", "스토리 4", "스토리 5", "스토리 6", "스토리 7", "스토리 8", "스토리 9", "스토리 10"]
    
  var body: some View {
      VStack {
          ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 8) { // 스토리 사이 간격 수정
                  ForEach(stories, id: \.self) { story in
                      VStack {
                          Circle()
                              .frame(width: 64, height: 64)
                              .foregroundColor(Color.blue)
                          Text(story)
                              .font(.caption)
                              .lineLimit(1)
                              .frame(width: 80)
                              .multilineTextAlignment(.center)
                      }
                  }
              }
              .padding(.horizontal, 0)
          }
          
          Divider() // 연한 회색 구분선 추가
              .padding(.top, 8)
              //.padding(.horizontal)
      }
      .padding(.top, 16)
  }
  
}
