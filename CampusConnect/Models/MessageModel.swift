//
//  MessageModel.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/02.
//

import Foundation


enum MessageType: String {
    case text = "text"
    case audio = "audio"
    case image = "image"
    case video = "video"
    case coordinates = "coordinates"
}

struct Message: Identifiable, Codable {
    var id: String?
    let content: String?
    let senderId: String?
    let senderName: String?
    let dateCreated: Date
    //var received: Bool
    let messageType: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case content = "content"
        case senderId = "sender_id"
        case senderName = "sender_name"
        case dateCreated = "date_created"
        case messageType = "message_type"
    }
    
}
