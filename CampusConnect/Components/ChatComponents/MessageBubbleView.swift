//
//  MessageBubbleView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI


struct MessageBubbleView: View {
    
    var message: Message
    var showNameAndTime: () -> Bool
    var isSentByCurrentUser: () -> Bool
    
    
    var body: some View {
        VStack(alignment: isSentByCurrentUser() ? .trailing : .leading) {
            
            if(showNameAndTime()){
                Text(message.senderName ?? "Anonymous")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(isSentByCurrentUser() ? .trailing : .leading, 25)
            }
            
            HStack {
                
                if(isSentByCurrentUser()){
                    if(showNameAndTime()) {
                        Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text(message.content ?? "")
                        .padding()
                        .background(isSentByCurrentUser() ? Color("SmithApple") : Color("LavenderGray"))
                        .cornerRadius(35)
                } else {
                    
                    Text(message.content ?? "")
                        .padding()
                        .background(isSentByCurrentUser() ? Color("SmithApple") : Color("LavenderGray"))
                        .cornerRadius(35)
                    
                    if(showNameAndTime()) {
                        Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
                
                
            }.frame(maxWidth: 300, alignment: isSentByCurrentUser() ? .trailing : .leading)
            
            /*Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(message.received ? .leading : .trailing, 25)
             */
            
        }
        .padding(isSentByCurrentUser() ? .trailing : .leading)
        .frame(maxWidth: .infinity, alignment: isSentByCurrentUser() ? .trailing : .leading)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        let message = Message(id: "message1", content: "Hi there. Coding is fun as long as you know how to make it fun.", senderId: "pYgifG6NKqYLexX5tOMytADwhVc2", senderName: "Jack Sparrow", dateCreated: Date(), messageType: "text")
        
        MessageBubbleView(message: message, showNameAndTime: {
            return true
        }, isSentByCurrentUser: {true})
    }
}

struct MessageBubbleView_Preview: PreviewProvider {
    static var previews: some View {
        let message = Message(id: "message1", content: "Hi there coding bot, you'll soon become a rigid machine machine.", senderId: "pYgifG6NKqYLexX5tOMytADwhVc2", senderName: "Anonymous", dateCreated: Date(), messageType: "text")
        MessageBubbleView(message: message, showNameAndTime: {
            return true
        }, isSentByCurrentUser: {false})
    }
}
