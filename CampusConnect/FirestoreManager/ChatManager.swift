//
//  ChatManager.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Message: Identifiable, Codable {
    var id: String?
    let content: String?
    let senderId: String?
    let senderName: String?
    let dateCreated: Date
    var received: Bool
    //let messageType: String
    
}

struct ChatGroup: Codable {
    var groupId: String?
    let groupName: String?
    let groupMembers: [String]?
    let groupAdmin: String?
    let recentMessage: Message?
    let groupProfileImage: String?
    let groupType: String?
    let dateCreated: Date
    
    
    init(groupMembers: [String], groupType: String) {
        self.groupId = nil
        self.groupName = nil
        self.groupMembers = groupMembers
        self.groupAdmin = groupMembers.first
        self.recentMessage = nil
        self.groupProfileImage = nil
        self.groupType = groupType
        self.dateCreated = Date()
    }
    
    init(groupId: String?, groupName: String?, groupMembers: [String]?, groupAdmin: String?, recentMessage: Message?, groupProfileImage: String?, groupType: String?, dateCreated: Date) {
        self.groupId = groupId
        self.groupName = groupName
        self.groupMembers = groupMembers
        self.groupAdmin = groupAdmin
        self.recentMessage = recentMessage
        self.groupProfileImage = groupProfileImage
        self.groupType = groupType
        self.dateCreated = dateCreated
    }
   
    
}

struct RecentMessage: Codable {
    //var id: String
    let content: String
    let senderId: String
    let senderName: String
    let messageType: String
    let dateCreated: Date
    //var received: Bool
}

final class ChatManager {
    
    static let shared = ChatManager()
    private init() { }
    
   
    private let enconder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let dencoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    
    
    //private let userCollection = Firestore.firestore().collection("users")
    private let groupCollection = Firestore.firestore().collection("groups")
    
    private func groupDocument(groupId: String) -> DocumentReference {
        return groupCollection.document(groupId)
    }
    
    
    // *--------------------------------- Chat Functions ---------------------------------* //
    private let chatCollection = Firestore.firestore().collection("chats")
   
    
    private func chatDocument(groupId: String) -> DocumentReference {
        return chatCollection.document(groupId)
    }
    
    
    // write to sender channel
    private func channelDocument(userId: String) -> DocumentReference {
        return chatCollection.document(userId)
    }
    
    // write to sender thread
    private func messageDocument(userId: String) -> DocumentReference {
        return chatCollection.document(userId)
            .collection("threads").document()
    }
    
    // to receiver channel db
    private func channelDocument(receiverId: String) -> DocumentReference {
        return chatCollection.document(receiverId)
    }
    
    // to receiver message db
    private func messageDocument(receiverId: String) -> DocumentReference {
        return chatCollection.document(receiverId)
            .collection("threads").document()
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
    // *--------------------------------- Chat Functions ---------------------------------* //
    
    func createChatGroup(groupData: ChatGroup) async throws {
        
        var data : [String:Any] = [
            //"group_members" : [userId],     // group creator
            "date_created" : Timestamp(),   // from firebase SDK
        ]
        
        
        if let groupAdmin = groupData.groupAdmin {
            data["group_admin"] = groupAdmin
        }
        
        if let groupName = groupData.groupName {
            data["group_name"] = groupName
        }
        
        
        // Invite members into the group
        if let groupMembers = groupData.groupMembers {
            data["group_members"] = FieldValue.arrayUnion(groupMembers) // appends new values to the current array

        }
        
        if let groupProfileImage = groupData.groupProfileImage {
            data["group_profile_image"] = groupProfileImage
        }
        
        if let groupType = groupData.groupType {
            data["group_type"] = groupType
        }
        
        
        // TODO: Updatee recent messages field
        // let recentMessage: RecentMessage?
        
        
        
        // 1. Add Document to groups collection
        let documentRef = try await groupCollection.addDocument(data: data)
        
        // 2. Update the group id from the document reference after t
        try await documentRef.updateData( ["group_id": documentRef.documentID] )
        
        
        /*let createdGroupId : [String:Any] = [
            "groups" : FieldValue.arrayUnion([documentRef]) // appends new values to the current array
        ]*/
        
        // 3. Add group to the group member's document
        //try await UserManager.shared.userDocument(userId: userId).updateData(createdGroupId)
        if let members = groupData.groupMembers {
            try await addGroupToMembersDoc(groupMembers: members, groupId: documentRef.documentID)
        }
       
        
    }
    
    
    // Updates each members groups list to contain the newly created group
    // Path: users/memeberId/
    func addGroupToMembersDoc(groupMembers: [String], groupId: String) async throws {
        let data: [String:Any] = [
            "groups" : FieldValue.arrayUnion([groupId]) // appends new values to the current array
        ]
        
        // Add groups to the document in  each member's user collection
        for memberId in groupMembers {
            try await UserManager.shared.userDocument(userId: memberId).updateData(data)
        }
    }
    
    // MARK: - TODO: invite persom
    // TODO: add invite member function
    
    
    // Sends messages to a group
    func sendMessage(groupId: String,  message: Message) async throws{
        var data : [String:Any] = [
            "received": message.received,
            "date_created" : Timestamp(),   // from firebase SDK
        ]
        
        if let content = message.content {
            data["content"] = content
        }
        
        if let senderId = message.senderId {
            data["sender_id"] = senderId
        }
        
        if let senderName = message.senderName {
            data["sender_name"] = senderName
        }
        
        if let senderId = message.senderId {
            data["sender_id"] = senderId
        }
        
        
        
        /*if let received = message.received {
            data["received"] = received
        }*/
        
        // 1. Add Document to messages collection
        let documentRef = try await chatDocument(groupId: groupId).collection("messages").addDocument(data: data)
        
        // 2. Update the message id from the document reference after t
        try await documentRef.updateData( ["id": documentRef.documentID] )
        
        guard let recentMessage = try? enconder.encode(message) else {
            // TODO: Customize error message
            throw URLError(.badServerResponse)
        }
        // 3. Update recent message in the groups collection
        try await groupDocument(groupId: groupId).updateData(recentMessage)
    }
    
    
    // This function is used when creating a group that has only 2 members
    // It returns whether a group containing the 2 members exist
    func groupExists(adminId: String, memberId: String)async throws -> Bool {
        var matchingGroups: [ChatGroup] = []
        
        let querySnapshot = try await groupCollection.whereField("group_members", isEqualTo: [adminId, memberId]).getDocuments()
        
        for document in querySnapshot.documents {
            
            let group = try document.data(as: ChatGroup.self, decoder: dencoder)
            matchingGroups.append(group)
        }
        
        return matchingGroups.isEmpty ? false : true
    }
    
    // This function is used for multi-person group chat
    // The first index in the members  contails the group's longest memeber (default admin)
    func groupExists(members: [String])async throws -> Bool {
        var matchingGroups: [ChatGroup] = []
        
        let querySnapshot = try await groupCollection.whereField("group_members", isEqualTo: members).getDocuments()
        
        for document in querySnapshot.documents {
            
            let group = try document.data(as: ChatGroup.self, decoder: dencoder)
            matchingGroups.append(group)
        }
        
        return matchingGroups.isEmpty ? false : true
    }
    
    
}
