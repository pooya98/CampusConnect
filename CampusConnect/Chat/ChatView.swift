//
//  ChatView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI



struct ChatView: View {
    //@Binding var showChatRoom: Bool
    //@State var showNameAndTime: Bool = true
    @State private var time: String = ""
    
    var groupId: String
    var profileImageUrl: String?
    var name: String?
    var messages: [Message]
    
    
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
                    VStack {
                        ForEach(messages, id: \.id) { message in
                         /*MessageBubbleView(showNameAndTime: $showNameAndTime ,message: Message(id: "218323h2bu2", content: message.content, senderId: "123123213", senderName: "Sparrow", dateCreated: Date(), received: true))*/
                            
                            
                         /*MessageBubbleView(showNameAndTime: {
                             let newTime = String(message.dateCreated.formatted(.dateTime.hour().minute()))
                             
                             return time == newTime ? false : true
                         }, message: message)*/
                         
                         }
                    }
                }
                .padding(.top, 10)
                //.background(.white)
                .background(Color(.gray))
                
            }
            //.background(Color("SmithApple"))
            
            //MessageFieldView(showNameAndTime: $showNameAndTime)
            MessageFieldView(groupId: groupId)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    
    static var previews: some View {
        //ChatView(showChatRoom: .constant(true))
        ChatView(groupId: "1234",messages: [Message(content: "Hey you Yoooo, what's up. How have you been?", senderId: "1234", senderName: "Anonymous", dateCreated: Date(), messageType: "text")])
    }
}
