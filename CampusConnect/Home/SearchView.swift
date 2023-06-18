//
//  SearchView2.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/06/08.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                // X 버튼
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(red: 247/255, green: 202/255, blue: 246/255))
                        .padding(10)
                        .background(Color.clear)
                }
                Spacer() // X 버튼 우측에 공간 추가
            }

            // NotificationView2의 나머지 내용 추가
            Text("검색")
                .font(.largeTitle)
            
            Spacer() // 나머지 콘텐츠 아래에 공간 추가
        }
        .padding() // 전체 콘텐츠에 패딩 적용
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
      SearchView()
    }
}
