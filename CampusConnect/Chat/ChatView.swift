//
//  ChatView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private (set) var time: String = ""
    @Published private(set) var groupMessages: [Message] = []
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        print("User: ", user as Any)
    }
    
    
    
    // TODO: Add an error message when user can load messages
    func loadMessages(groupId: String) async throws {
        self.groupMessages = try await ChatManager.shared.getMessages(groupId: groupId)
        print("Messages: ", groupMessages)
    }
    
    // get authenticated userId and compare with senderId
    func showNameAndTime(message: Message) -> Bool{
        
        if(String(message.dateCreated.formatted(.dateTime.hour().minute())) == time) {
            return false
                          
        } else {
            //time = String(message.dateCreated.formatted(.dateTime.hour().minute()))
            return true
        }
    }
}

struct ChatView: View {
    
    // MARK: - Used observed Object instead of state Object
    
    @StateObject private var chatViewModel = ChatViewModel()
    //@Binding var showChatRoom: Bool
    //@State var showNameAndTime: Bool = true
    
    
    var groupId: String
    var profileImageUrl: String?
    var name: String?
    //var messages: [Message]
    
    
    var body: some View {
        VStack {
            VStack {
                
                ChatTitleView(profileimageUrl: profileImageUrl, name: name)
                
                ScrollView {
                    VStack {
                        ForEach(chatViewModel.groupMessages, id: \.id) { message in
                         
                            MessageBubbleView(message: message) {
                                chatViewModel.showNameAndTime(message: message)
                            } isSentByCurrentUser: {
                                // user.UserId: String
                                // message.senderId: String?
                                return chatViewModel.user?.userId == message.senderId
                            }
                            

                         }
                    }
                }
                .padding(.top, 10)
                //.background(.white)
                //.background(Color(.gray))
                
            }
            .background(chatViewModel.groupMessages.isEmpty ? Color(.white) : Color("SmithApple"))
            
            //MessageFieldView(showNameAndTime: $showNameAndTime)
            MessageFieldView(groupId: groupId)
        }.task {
            try? await chatViewModel.loadCurrentUser()
            print("groupId: ", groupId)
            try? await chatViewModel.loadMessages(groupId: groupId)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    
   /* static var previews: some View {
        //ChatView(showChatRoom: .constant(true))
        ChatView(groupId: "1234",messages: [Message(content: "Hey you Yoooo, what's up. How have you been?", senderId: "1234", senderName: "Anonymous", dateCreated: Date(), messageType: "text"), Message(content: "Hey you Yoooo, what's up. How have you been?", senderId: "1234", senderName: "Anonymous", dateCreated: Date(), messageType: "text"), Message(content: "Hey you Yoooo, what's up. How have you been?", senderId: "1234", senderName: "Anonymous", dateCreated: Date(), messageType: "text")])
    }*/
    
    static var previews: some View {
        //ChatView(showChatRoom: .constant(true))
        ChatView(groupId: "1234")
    }
}
