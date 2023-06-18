//
//  DBUserModel.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/02.
//

import Foundation


struct DBUser: Codable, Hashable {
    let userId: String // Use this in ForEach id to confirm to type Identifiable
    let firstName: String?
    let lastName: String?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let profileImageUrl: String?
    let profileImagePath: String?
    let friendList: [String]?
    let department: String?
    let studentId: String?
    var groups: [String]?
    var meetUps: [String]?
    //var isSelected: Bool = false
    //let isActive: Bool = true
    
    // for identifiable
    /*var id: String {
        userId
    }*/

    // MARK: -  CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case photoUrl = "Photo_url"
        case dateCreated = "date_created"
        case profileImageUrl = "profile_image_url"
        case profileImagePath = "profile_image_path"
        case friendList = "friend_list"
        case department = "department"
        case studentId = "student_id"
        case groups = "groups"
        case meetUps = "meet_ups"
    }
    
    
    // Utilized in CreateAccountViewModel when creating a new user account
    init(authData: AuthDataResultModel, accountDetails: AccountRegistrationDetails) {
        self.userId = authData.uid
        self.firstName = accountDetails.firstName
        self.lastName = accountDetails.lastName
        self.email = authData.email
        self.photoUrl = authData.photoUrl
        self.dateCreated = Date()
        self.profileImageUrl = nil
        self.profileImagePath = nil
        self.friendList =  nil
        // TODO: Modify department and studentId initialization to a value provided by the user
        self.department = nil
        self.studentId = nil
        self.groups = nil
        self.meetUps = nil
    }
    
    //
    /*init(userId: String, firstName: String?, lastName: String?, email: String?, photoUrl: String?, dateCreated: Date?, profileImageUrl: String?, profileImagePath: String?, friendList: [String]?, department: String?, studentId: String?, groups: [String]?, meetUps: [String]?) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.profileImageUrl = profileImageUrl
        self.profileImagePath = profileImagePath
        self.friendList = friendList
        self.department = department
        self.studentId = studentId
        self.groups = groups
        self.meetUps = meetUps
    }*/
    
}
