//
//  StoryDetailView2.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/06/08.
//

import SwiftUI

struct StoryDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let story: Story
    @State private var isStoryActive = true
    @State private var progressValue: Float = 0.0
    @State private var isPlaying = true
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            Image(story.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ProgressView(value: progressValue, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.white))
                    .frame(height: 2)
                    .padding([.top, .leading, .trailing])
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        // 메시지 보내기 버튼 클릭 시 액션 구현 필요
                    }) {
                        Image(systemName: "text.bubble")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // 하트 버튼 클릭 시 액션 구현 필요
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding([.leading, .trailing, .bottom])
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isPlaying.toggle()
                    }) {
                        Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding([.trailing, .bottom])
                }
            }
        }
        .onAppear {
            let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
                if progressValue < 100 && isPlaying {
                    progressValue += 1
                } else if progressValue >= 100 {
                    timer.invalidate()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            RunLoop.current.add(timer, forMode: .common)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(story: Story(imageName: "profile1", username: "Username1"))
    }
}
