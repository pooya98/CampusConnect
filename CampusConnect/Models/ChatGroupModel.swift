//
//  Models.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/02.
//

import Foundation

enum GroupType: String {
    case twoPerson = "two-person"
    case multiPerson = "multi-person"
}

struct ChatGroup: Codable {
    var groupId: String?
    let groupName: String?
    let groupMembers: [String]?
    let groupAdminId: [String]?
    let displayName: [String]?
    var displayImage: String?
    let recentMessage: Message?
    let groupProfileImage: String?
    let groupType: String?
    let dateCreated: Date
    
    
    
    // using default coding keys
    enum CodingKeys: String, CodingKey {
        case groupId = "group_id"
        case groupName = "group_name"
        case groupMembers = "group_members"
        case groupAdminId = "group_admin_id"
        case displayName = "display_name"
        case displayImage = "display_Image"
        case recentMessage = "recent_message"
        case groupProfileImage = "group_profile_image"
        case groupType = "group_type"
        case dateCreated = "date_created"
    }
    
    
    init(groupMembers: [String], groupType: String, displayName: [String]?) {
        self.groupId = nil
        self.groupName = nil
        self.groupMembers = groupMembers
        self.groupAdminId = [groupMembers.first ?? ""]
        self.displayName = displayName
        self.displayImage = nil
        self.recentMessage = nil
        self.groupProfileImage = nil
        self.groupType = groupType
        self.dateCreated = Date()
    }

    
    // groupId will be provided by firestore
    // groupName will be used insted of displayName
    // groupProfileImage will be used insted of displayImage
    init(groupId: String? = nil, groupName: String?, groupMembers: [String]?, groupAdminId: [String]?, displayName: [String]? = nil, displayImage: String? = nil, recentMessage: Message?, groupProfileImage: String?, groupType: String?, dateCreated: Date) {
        self.groupId = groupId
        self.groupName = groupName
        self.groupMembers = groupMembers
        self.groupAdminId = groupAdminId
        self.displayName = displayName
        self.displayImage = displayImage
        self.recentMessage = recentMessage
        self.groupProfileImage = groupProfileImage
        self.groupType = groupType
        self.dateCreated = dateCreated
    }
   
    
}
