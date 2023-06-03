//
//  ChatManager.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


final class ChatManager {
    
    static let shared = ChatManager()
    private init() { }
    
   
    private var messagesListener: ListenerRegistration? = nil
    
    private let enconder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    /*private let dencoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()*/
    
    //private let userCollection = Firestore.firestore().collection("users")
    private let groupCollection = Firestore.firestore().collection("groups")
    
    
    private func groupDocument(groupId: String) -> DocumentReference {
        return groupCollection.document(groupId)
    }
    
    
    private let chatCollection = Firestore.firestore().collection("chats")
   
    
    private func chatDocument(groupId: String) -> DocumentReference {
        return chatCollection.document(groupId)
    }
    
    
    // MARK: - Group Functions
    // ********************************** Group Functions ********************************** //
    
    // Creates group and returns the groupId
    func createChatGroup(groupData: ChatGroup) async throws -> String{
        
        var data : [String:Any] = [
            //"group_members" : [userId],     // group creator
            ChatGroup.CodingKeys.dateCreated.rawValue : Timestamp(),   // from firebase SDK
        ]
        
        
        if let groupAdminId = groupData.groupAdminId {
            data[ChatGroup.CodingKeys.groupAdminId.rawValue] = FieldValue.arrayUnion(groupAdminId)
        }
        
        if let displayName = groupData.displayName {
            data[ChatGroup.CodingKeys.displayName.rawValue] = FieldValue.arrayUnion(displayName)
        }
        
        if let displayImage = groupData.displayImage {
            data[ChatGroup.CodingKeys.displayImage.rawValue] = displayImage
        }
        
        if let groupName = groupData.groupName {
            data[ChatGroup.CodingKeys.groupName.rawValue] = groupName
        }
        
        
        // Invite members into the group
        if let groupMembers = groupData.groupMembers {
            data[ChatGroup.CodingKeys.groupMembers.rawValue] = FieldValue.arrayUnion(groupMembers) // appends new values to the current array

        }
        
        if let groupProfileImage = groupData.groupProfileImage {
            data[ChatGroup.CodingKeys.groupProfileImage.rawValue] = groupProfileImage
        }
        
        if let groupType = groupData.groupType {
            data[ChatGroup.CodingKeys.groupType.rawValue] = groupType
        }
        
        
        // TODO: Update recent messages field
        // let recentMessage: RecentMessage?
        
        
        
        // 1. Add Document to groups collection
        let documentRef = try await groupCollection.addDocument(data: data)
        
        // 2. Update the group id from the document reference after t
        try await documentRef.updateData( [ChatGroup.CodingKeys.groupId.rawValue: documentRef.documentID] )
        
        // 3. Add group to the group member's document
        //try await UserManager.shared.userDocument(userId: userId).updateData(createdGroupId)
        if let members = groupData.groupMembers {
            try await addGroupToMembersDoc(groupMembers: members, groupId: documentRef.documentID)
        }
       
        return documentRef.documentID
    }
    
    
    // Updates each members groups list to contain the newly created group
    // Path: users/memeberId/
    func addGroupToMembersDoc(groupMembers: [String], groupId: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.groups.rawValue : FieldValue.arrayUnion([groupId]) // appends new values to the current array
        ]
        
        // Add groups to the document in  each member's user collection
        for memberId in groupMembers {
            try await UserManager.shared.userDocument(userId: memberId).updateData(data)
        }
    }
    
    // MARK: - TODO: invite persom
    // TODO: add invite member function
    
    // This function is used when creating a group that has only 2 members
    // It returns whether a group containing the 2 members exist
    func groupExists(adminId: String, memberId: String)async throws -> (isPresent: Bool, groupId: String?) {
        var matchingGroups: [ChatGroup] = []
        
        let querySnapshot = try await groupCollection.whereField(ChatGroup.CodingKeys.groupMembers.rawValue, isEqualTo: [adminId, memberId]).getDocuments()
        
        for document in querySnapshot.documents {
            
            let group = try document.data(as: ChatGroup.self)
            matchingGroups.append(group)
        }
        
        let existStatus = matchingGroups.isEmpty ? false : true
        
        return (existStatus, matchingGroups.first?.groupId)
        
    }
    
    
    // This function is used for multi-person group chat
    // The first index in the members  contails the group's longest memeber (default admin)
    /*func groupExists(members: [String])async throws -> Bool {
        var matchingGroups: [ChatGroup] = []
        
        let querySnapshot = try await groupCollection.whereField(ChatGroup.CodingKeys.groupMembers.rawValue, isEqualTo: members).getDocuments()
        
        for document in querySnapshot.documents {
            
            let group = try document.data(as: ChatGroup.self)
            matchingGroups.append(group)
        }
        
        return matchingGroups.isEmpty ? false : true
    }*/
    
    
    /*func getGroups()  async throws -> [ChatGroup] {
        try await groupCollection.order(by: ChatGroup.CodingKeys.recentMessage.rawValue).getDocuments(as: ChatGroup.self)
    }*/
    
    func getGroups(userId: String)  async throws -> [ChatGroup] {
        
        var groups: [ChatGroup] = []
        let querySnapshot = try await groupCollection
            .whereField(ChatGroup.CodingKeys.groupMembers.rawValue, arrayContains: userId)
            .whereField(ChatGroup.CodingKeys.recentMessage.rawValue, isNotEqualTo: "").order(by: ChatGroup.CodingKeys.recentMessage.rawValue, descending: true).getDocuments()
        
        for document in querySnapshot.documents{
            let group = try document.data(as: ChatGroup.self)
            
            if (group.groupType == GroupType.twoPerson.rawValue) {
                // fetch
            }
            groups.append(group)
        }
        
        return groups
    }
   
    

    // ********************************** Group Functions ********************************** //
    
    
    
    // MARK: - Chat Thread Functions
    // ********************************** Chat Thread Functions ********************************** //
   
    // Add a snapshot listerner for real-time message fetch
    func addListenerForAllMessages(groupId: String, completion: @escaping (_ messages: [Message], _ lastMessageId: String?) -> Void) {
        
        self.messagesListener = chatDocument(groupId: groupId).collection("messages").order(by: Message.CodingKeys.dateCreated.rawValue).addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("Error fetcing message documents: \(String(describing: error?.localizedDescription))")
                return
            }
            
            print("Listener will send a message soon...")
            //  Using completion handler
            let messages: [Message] = documents.compactMap({ try? $0.data(as: Message.self)})
            completion(messages, messages.last?.id)
        }
    }
    
    
    func removeListenerForMessages() {
        self.messagesListener?.remove()
    }
    
    // Write Data Method 2: hard code key and value
    /*func sendMessage(message: Message, userId: String) async throws {
        var messageDetails : [String:Any] = [
            "id": message.id,
            "date_created" : Timestamp() // from firebase SDK
        ]
        

        if let content = message.content {
            messageDetails["content"] = content
        }
        
        if let senderId = message.senderId {
            messageDetails["sender_id"] = senderId
        }
        
        if let senderName = message.senderName {
            messageDetails["sender_name"] = senderName
        }
        
        if let received = message.received {
            messageDetails["received"] = received
        }
        
        try await channelDocument(userId: userId).setData(messageDetails, merge: false)
    }*/
    
    // Sends messages to a group
    func sendMessage(groupId: String,  message: Message) async throws{
        var data : [String:Any] = [
            //"received": message.received,
            Message.CodingKeys.dateCreated.rawValue : Timestamp(),   // from firebase SDK
        ]
        
        if let content = message.content {
            data[Message.CodingKeys.content.rawValue] = content
        }
        
        if let senderId = message.senderId {
            data[Message.CodingKeys.senderId.rawValue] = senderId
        }
        
        if let senderName = message.senderName {
            data[Message.CodingKeys.senderName.rawValue] = senderName
        }
        
        if let messageType = message.messageType {
            data[Message.CodingKeys.messageType.rawValue] = messageType
        }
        
        
        // 1. Add Document to messages collection
        let documentRef = try await chatDocument(groupId: groupId).collection("messages").addDocument(data: data)
        
        // 2. Update the message id from the document reference after t
        try await documentRef.updateData( [Message.CodingKeys.id.rawValue: documentRef.documentID] )
        
        guard let recentMessage = try? enconder.encode(message) else {
            // TODO: Customize error message
            print("Error adding message to database")
            throw URLError(.badServerResponse)
        }
        // 3. Update recent message in the groups collection
        try await groupDocument(groupId: groupId).updateData([ChatGroup.CodingKeys.recentMessage.rawValue : recentMessage])
    }
    
    // TODO: send message utilizing codable
    
    // Fetch messages utilizing Codable protocol
    /*func getMessages(groupId: String) async throws -> [Message] {
        //try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: dencoder)
        
        let documents = try await chatDocument(groupId: groupId).collection("messages").fetchDocumets(as: Message.self)
        
        print("Messages", documents)
        return documents
    }*/
    
    // fetch messeges
    func getMessages(groupId: String) async throws -> [Message] {
       
        var messages: [Message] = []
        let querySnapshot = try await chatDocument(groupId: groupId).collection("messages").order(by: Message.CodingKeys.dateCreated.rawValue).getDocuments()
        
        for document in querySnapshot.documents {
            
            let message = try document.data(as: Message.self)
            
            messages.append(message)
        }
        
        return messages
        
    }
    
    
    // ********************************** Chat Thread Functions ********************************** //
    
    
   
    
    
    
    
    
    
    
  
    
    
    
    
   
    
    
    
    
   
    
    
    
    
}
