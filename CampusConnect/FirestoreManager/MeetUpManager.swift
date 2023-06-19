//
//  MeetUpManager.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class MeetUpManager {
    
    static var shared = MeetUpManager()
    private init() { }
    
    
    private let meetUpCollection = Firestore.firestore().collection("meetUps")
    
    private func meetUpDocument(groupId: String) -> DocumentReference {
        return meetUpCollection.document(groupId)
    }
    
    
    // Creates meet-up group and returns the groupId
    func createMeetUpGroup(groupData: MeetUpGroup) async throws -> String{
        
        var data : [String:Any] = [
            //"group_members" : [userId],     // group creator
            MeetUpGroup.CodingKeys.dateCreated.rawValue : Timestamp(),   // from firebase SDK
        ]
        
        
        if let groupAdminId = groupData.groupAdminId {
            data[MeetUpGroup.CodingKeys.groupAdminId.rawValue] = FieldValue.arrayUnion(groupAdminId)
        }
        
        
        if let groupName = groupData.groupName {
            data[MeetUpGroup.CodingKeys.groupName.rawValue] = groupName
        }
        
        
        // Invite members into the group
        if let groupMembers = groupData.groupMembers {
            data[MeetUpGroup.CodingKeys.groupMembers.rawValue] = FieldValue.arrayUnion(groupMembers) // appends new values to the current array

        }
        
        
        if let groupProfileImageUrl = groupData.groupProfileImageUrl {
            data[MeetUpGroup.CodingKeys.groupProfileImageUrl.rawValue] = groupProfileImageUrl
        }
        
        
        if let groupProfileImagePath = groupData.groupProfileImagePath {
            data[MeetUpGroup.CodingKeys.groupProfileImagePath.rawValue] = groupProfileImagePath
        }
        
        if let department = groupData.department {
            data[MeetUpGroup.CodingKeys.department.rawValue] = department
        }
        
        if let meetingType = groupData.meetingType {
            data[MeetUpGroup.CodingKeys.meetingType.rawValue] = meetingType
        }
        
        if let meetingDay = groupData.meetingDay {
            data[MeetUpGroup.CodingKeys.meetingDay.rawValue] = meetingDay
        }
        
        if let meetingDate = groupData.meetingDate {
            data[MeetUpGroup.CodingKeys.meetingDate.rawValue] = meetingDate
        }
        
        
        // 1. Add Document to groups collection
        let documentRef = try await meetUpCollection.addDocument(data: data)
        
        // 2. Update the group id from the document reference after t
        try await documentRef.updateData( [MeetUpGroup.CodingKeys.groupId.rawValue: documentRef.documentID] )
        
        /*
        // 3. Add group to the group member's document
        //try await UserManager.shared.userDocument(userId: userId).updateData(createdGroupId)
        if let members = groupData.groupMembers {
            try await addGroupToMembersDoc(groupMembers: members, groupId: documentRef.documentID)
        }
        */
       
        return documentRef.documentID
    }
    
    func getMeetUps(userId: String)  async throws -> [MeetUpGroup] {
        
        var groups: [MeetUpGroup] = []
        let querySnapshot = try await meetUpCollection
            .whereField(MeetUpGroup.CodingKeys.groupMembers.rawValue, arrayContains: userId).order(by: MeetUpGroup.CodingKeys.dateCreated.rawValue).getDocuments()
        
        for document in querySnapshot.documents{
            let group = try document.data(as: MeetUpGroup.self)
            
            groups.append(group)
        }
        
        return groups
    }
    
    func updateMeetUpProfileImage(groupId: String, path: String?, url: String?) async throws {
      
        let data: [String:Any] = [
            MeetUpGroup.CodingKeys.groupProfileImagePath.rawValue : path as Any,
            MeetUpGroup.CodingKeys.groupProfileImageUrl.rawValue : url as Any,
        ]
        
        try await meetUpDocument(groupId: groupId).updateData(data)
    }
    
    
    
}
