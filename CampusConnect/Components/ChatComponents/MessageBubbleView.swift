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
    @State private var time: String = ""
    @Binding var showNameAndTime: Bool
   
    var message: Message
    
    
    var body: some View {
        VStack(alignment: message.received ? .leading : .trailing) {
            
            if(showNameAndTime){
                Text(message.senderName)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(message.received ? .leading : .trailing, 25)
            }
            
            HStack {
                Text(message.content)
                    .padding()
                    .background(message.received ? Color("LavenderGray") : Color("SmithApple"))
                    .cornerRadius(35)
                
                if(showNameAndTime) {
                    Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
            }.frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
            
            /*Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(message.received ? .leading : .trailing, 25)
             */
            
        }
        .padding(message.received ? .leading : .trailing)
        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        let message = Message(id: "message1", content: "Hi there. Coding is fun as long as you know how to make it fun.", senderId: "pYgifG6NKqYLexX5tOMytADwhVc2", senderName: "Jack Sparrow", dateCreated: Date(), received: true)
        MessageBubbleView(showNameAndTime: .constant(true), message: message)
    }
}
