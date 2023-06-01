//
//  MessageBubbleView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

@MainActor
final class MessageBubbleViewModel: ObservableObject {
    
    // get authenticated userId and compare with senderId
    func alignRight(senderId: String) throws -> Bool{
        let authData = try AuthenticationManager.shared.getAuthenticatedUser()
        return senderId == authData.uid
    }
}

struct MessageBubbleView: View {
    @StateObject private var messageBubbleViewModel = MessageBubbleViewModel()
    var showNameAndTime: () -> Bool
   
    var message: Message
    var isSentbyMe: Bool
    
    
    var body: some View {
        VStack(alignment: isSentbyMe ? .trailing : .leading) {
            
            if(showNameAndTime()){
                Text(message.senderName ?? "Anonymous")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(isSentbyMe ? .trailing : .leading, 25)
            }
            
            HStack {
                
                if(isSentbyMe){
                    if(showNameAndTime()) {
                        Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text(message.content ?? "")
                        .padding()
                        .background(isSentbyMe ? Color("SmithApple") : Color("LavenderGray"))
                        .cornerRadius(35)
                } else {
                    
                    Text(message.content ?? "")
                        .padding()
                        .background(isSentbyMe ? Color("SmithApple") : Color("LavenderGray"))
                        .cornerRadius(35)
                    
                    if(showNameAndTime()) {
                        Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
                
                
            }.frame(maxWidth: 300, alignment: isSentbyMe ? .trailing : .leading)
            
            /*Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(message.received ? .leading : .trailing, 25)
             */
            
        }
        .padding(isSentbyMe ? .trailing : .leading)
        .frame(maxWidth: .infinity, alignment: isSentbyMe ? .trailing : .leading)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        let message = Message(id: "message1", content: "Hi there. Coding is fun as long as you know how to make it fun.", senderId: "pYgifG6NKqYLexX5tOMytADwhVc2", senderName: "Jack Sparrow", dateCreated: Date(), messageType: "text")
        
        MessageBubbleView(showNameAndTime: {
            return true
        }, message: message, isSentbyMe: true)
    }
}

struct MessageBubbleView_Preview: PreviewProvider {
    static var previews: some View {
        let message = Message(id: "message1", content: "Hi there coding bot, you'll soon become a rigid machine machine.", senderId: "pYgifG6NKqYLexX5tOMytADwhVc2", senderName: "Anonymous", dateCreated: Date(), messageType: "text")
        MessageBubbleView(showNameAndTime: {
            return true
        }, message: message, isSentbyMe: false)
    }
}
