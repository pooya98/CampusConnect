//
//  MessageFieldView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

@MainActor
final class MessageFieldViewModel: ObservableObject {
    @Published var message: [String] = []
    
    func sendTextMessage(groupId: String) async throws {
        
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        let messageObject = Message(id: nil, content: message.first, senderId: user.userId, senderName: user.firstName, dateCreated: Date(), messageType: "text")
        
        try await ChatManager.shared.sendMessage(groupId: groupId, message: messageObject)
        
    }
}

struct MessageFieldView: View {
    @StateObject private var messageFieldViewModel = MessageFieldViewModel()
    @State private var stateMessage = ""
    //@State private var time: String = ""
    //@Binding var showNameAndTime:Bool
    var groupId: String
    
    var body: some View {
        VStack {
            HStack {
                //CustomTextField(placeholder: Text("Message..."), text: $messageFieldViewModel.message)
                CustomTextField(placeholder: Text("Message..."), text: $stateMessage)
                
                Button {
                    // display name and time  only when the time differs for messages sent
                    /*if(time == String(Date().formatted(.dateTime.hour().minute()))) {
                        showNameAndTime = false
                    }
                    else {
                        showNameAndTime = true
                    }*/
                    
                    // time when message is sent
                    //time = Date().formatted(.dateTime.hour().minute())
                    Task{
                        messageFieldViewModel.message.append(stateMessage)
                        
                        // Reset TextField
                        stateMessage = ""
                        
                        //  MARK: - TODO
                        // TODO: implement error message when groupID is empty i.e group doesn't exist. Display error message to User
                        //  Don't forget to change the default groupId set in Add friend View when ChatView is called
                        try await messageFieldViewModel.sendTextMessage(groupId: groupId)
                        
                        print("Message sent!")
                        
                        messageFieldViewModel.message.removeFirst()
                        
                    }
                    
                    
                    
                } label: {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                        .foregroundColor(.black.opacity(0.7))
                        .background(Color("LumGreen"))
                        .cornerRadius(15)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color("LavenderGray"))
            .cornerRadius(20)
            .padding()
        }
        //.background(Color("PlumWeb"))
    }
}

struct MessageFieldView_Previews: PreviewProvider {
    static var previews: some View {
       // MessageFieldView(showNameAndTime: .constant(true))
        MessageFieldView(groupId: "1234")
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
