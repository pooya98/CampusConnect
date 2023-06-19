//
//  GroupModel.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/17.
//

import Foundation

//
//  ClubModel.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/17.
//

import Foundation

enum MeetingType: String, CaseIterable, Identifiable {
    case none = "none"
    case regular = "Regular meeting"
    case irregular = "Irregular meeting"
    case oneTime = "One-time meeting"
    
    // NOTE: Enum case without associated value conforms to Hashable by default. We can use self as an id.
    var id: Self { self }
}


enum MeetingDay: String, CaseIterable, Identifiable {
    case none = "none"
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
    
    var id: Self { self }
}

struct MeetUpGroup: Codable {
    var groupId: String?
    let groupName: String?
    let groupMembers: [String]?
    let groupAdminId: [String]?
    var groupProfileImageUrl: String?
    let groupProfileImagePath: String?
    let department: String?
    let meetingType: String?
    let meetingDay: String?
    let meetingDate: Date?
    let dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case groupId = "group_id"
        case groupName = "group_name"
        case groupMembers = "group_members"
        case groupAdminId = "group_admin_id"
        case groupProfileImageUrl = "group_profile_image_url"
        case groupProfileImagePath = "group_profile_image_path"
        case department = "department"
        case meetingType = "meeting_type"
        case meetingDay = "meeting_day"
        case meetingDate = "meeting_date"
        case dateCreated = "dateCreated"
    }
}
