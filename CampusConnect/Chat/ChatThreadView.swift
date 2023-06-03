//
//  ChatThreadView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

@MainActor
final class ChatThreadViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private (set) var time: String = ""
    @Published private(set) var groupMessages: [Message] = []
    @Published private(set) var lastMessageId: String? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        print("Current User: ", user?.firstName as Any)
    }
    
    
    
    // TODO: Add an error message when user can load messages
    /*func loadMessages(groupId: String) async throws {
        self.groupMessages = try await ChatManager.shared.getMessages(groupId: groupId)
        print("last message: ", groupMessages.last as Any)
    }*/
    
    
    func addListenerForMessages(groupId: String) {
        ChatManager.shared.addListenerForAllMessages(groupId: groupId) { [weak self]messages, messageId in
            self?.groupMessages = messages
            self?.lastMessageId = messageId
           
        }
    }
    
    
    func removeListener() {
        ChatManager.shared.removeListenerForMessages()
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

struct ChatThreadView: View {
    
    // MARK: - Used observed Object instead of state Object
    
    @StateObject private var chatThreadViewModel = ChatThreadViewModel()
    @State private var didAppear: Bool = false
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
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            ForEach(chatThreadViewModel.groupMessages, id: \.id) { message in
                             
                                MessageBubbleView(message: message) {
                                    chatThreadViewModel.showNameAndTime(message: message)
                                } isSentByCurrentUser: {
                                    // user.UserId: String
                                    // message.senderId: String?
                                    return chatThreadViewModel.user?.userId == message.senderId
                                }
                                

                             }
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .onChange(of: chatThreadViewModel.lastMessageId) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                        
                    }
                }
                //.background(Color(.gray))
                
            }
            .background(chatThreadViewModel.groupMessages.isEmpty ? Color(.white) : Color("SmithApple"))
            
            //MessageFieldView(showNameAndTime: $showNameAndTime)
            MessageFieldView(groupId: groupId)
        }
        .task {
            // MARK: - TODO
            // TODO: user a do catch to capture the error
            try? await chatThreadViewModel.loadCurrentUser()
            print("groupId: ", groupId)
            
            //try? await chatThreadViewModel.loadMessages(groupId: groupId)
        }
        .onAppear {
            if(!didAppear){
                chatThreadViewModel.addListenerForMessages(groupId: groupId)
                didAppear = true
                print("Messeges listener added")
            }
            
        }
        .onDisappear{
            // TODO: Test whether listener was really removed
            chatThreadViewModel.removeListener()
            print("Messages listener removed")
        }
    }
}

struct ChatThreadView_Previews: PreviewProvider {
    
   /* static var previews: some View {
        //ChatThreadView(showChatRoom: .constant(true))
        ChatThreadView(groupId: "1234",messages: [Message(content: "Hey you Yoooo, what's up. How have you been?", senderId: "1234", senderName: "Anonymous", dateCreated: Date(), messageType: "text"), Message(content: "Hey you Yoooo, what's up. How have you been?", senderId: "1234", senderName: "Anonymous", dateCreated: Date(), messageType: "text"), Message(content: "Hey you Yoooo, what's up. How have you been?", senderId: "1234", senderName: "Anonymous", dateCreated: Date(), messageType: "text")])
    }*/
    
    static var previews: some View {
        //ChatThreadView(showChatRoom: .constant(true))
        ChatThreadView(groupId: "1234")
    }
}
