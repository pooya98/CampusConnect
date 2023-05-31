//
//  ChatView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

@MainActor



struct ChatView: View {
    //@Binding var showChatRoom: Bool
    @State var showNameAndTime: Bool = true
    
    var friend: DBUser?
    var groupId: String?
    var profileImageUrl: String?
    var name: String?
    
    var messageArray = ["Hey you", "Yoooo, what's up. How have you been?", "I'm doing well. What about you?", "I'm fine. Just doing my best to graduate", "gooooo", "fooom, what are you up to. Leoni", "Kuja. Whats up you?", "doing my best to graduate"]
    
    var body: some View {
        VStack {
            VStack {
                
                /*HStack{
                    Button {
                        showChatRoom = false
                    } label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            //.foregroundColor(.black)
                            .frame(width: 10, height: 18)
                        Text("Back").font(.title3)
                            
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }*/
               

                ChatTitleView(profileimageUrl: profileImageUrl, name: name)
                
                ScrollView {
                    /*ForEach(messageArray, id: \.self) { content in
                        MessageBubbleView(showNameAndTime: $showNameAndTime ,message: Message(id: "218323h2bu2", content: content, senderId: "123123213", senderName: "Sparrow", dateCreated: Date(), received: true))
                        
                    }*/
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
        //ChatView(showChatRoom: .constant(true))
        ChatView()
    }
}
