//
//  ChatView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI


struct ChatView: View {
    @State var showNameAndTime: Bool = true
    
    var messageArray = ["Hey you", "Yoooo, what's up. How have you been?", "I'm doing well. What about you?", "I'm fine. Just doing my best to graduate", "Hey you", "Yoooo, what's up. How have you been?", "I'm doing well. What about you?", "I'm fine. Just doing my best to graduate"]
    
    var body: some View {
        VStack {
            VStack {
                ChatTitleView()
                
                ScrollView {
                    ForEach(messageArray, id: \.self) { content in
                        MessageBubbleView(showNameAndTime: $showNameAndTime ,message: Message(id: "218323h2bu2", content: content, senderId: "123123213", senderName: "Sparrow", dateCreated: Date(), received: true))
                        
                    }
                }
                .padding(.top, 10)
                .background(.white)
            }
            .background(Color("SmithApple"))
            
            MessageFieldView(showNameAndTime: $showNameAndTime)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
