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
    var id: String
    let content: String
    let senderId: String
    let senderName: String
    let dateCreated: Date
    var received: Bool
    
}

final class ChatManager {
    
    static let shared = ChatManager()
    private init() { }
    
    private let chatCollection = Firestore.firestore().collection("chats")
    
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
    
}
