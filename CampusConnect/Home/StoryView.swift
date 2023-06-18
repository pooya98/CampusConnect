//
//  StoryView2.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/06/08.
//

import SwiftUI

struct StoryView: View {
    let story: Story
    
    var body: some View {
        VStack {
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 213/255, green: 213/255, blue: 247/255),
                                Color(red: 252/255, green: 211/255, blue: 246/255),
                                Color(red: 255/255, green: 216/255, blue: 197/255),
                                Color(red: 255/255, green: 218/255, blue: 141/255)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 2.5)
                )
                .padding(.bottom, 4) // 스토리를 아래로 이동시키는 여백
                .padding(.top, 2) // 스토리 윗부분이 잘리는 부분 조정
            Text(story.username)
                .font(.caption)
                .foregroundColor(.black)
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView(story: Story(imageName: "profile1", username: "Username1"))
    }
}
