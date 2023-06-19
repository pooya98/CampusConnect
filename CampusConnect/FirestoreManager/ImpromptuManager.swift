//
//  ImpromptuManager.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/06/19.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ImpromptuManager {
    
    static var shared = ImpromptuManager()
    private init() { }
    
    
    private let impromptuCollection = Firestore.firestore().collection("impromptus")
    
    private func ImpromptuDocument(impromtuId: String) -> DocumentReference {
        return impromptuCollection.document(impromtuId)
    }
    
    
    // Creates meet-up group and returns the groupId
    func createImpromptu(impromptuData: Impromptu) async throws -> String{
        
        var data : [String:Any] = [
            Impromptu.CodingKeys.dateCreated.rawValue : Timestamp(),   // from firebase SDK
        ]
        
        
        if let ImpromptuAdminId = impromptuData.ImpromptuAdminId {
            data[Impromptu.CodingKeys.ImpromptuAdminId.rawValue] = ImpromptuAdminId
        }
        
        
        if let ImpromptuName = impromptuData.ImpromptuName {
            data[Impromptu.CodingKeys.ImpromptuName.rawValue] = ImpromptuName
        }
        
        
        
        if let ImpromptuImageUrl = impromptuData.ImpromptuImageUrl{
            data[Impromptu.CodingKeys.ImpromptuImageUrl.rawValue] = ImpromptuImageUrl
        }
        
        
        if let ImpromptuImagePath = impromptuData.ImpromptuImagePath {
            data[Impromptu.CodingKeys.ImpromptuImagePath.rawValue] = ImpromptuImagePath
        }
        
        if let ImpromptuLocation = impromptuData.ImpromptuLocation {
            data[Impromptu.CodingKeys.ImpromptuLocation.rawValue] = ImpromptuLocation
        }
        
        if let ImpromptuTime = impromptuData.ImpromptuTime {
            data[Impromptu.CodingKeys.ImpromptuTime.rawValue] = ImpromptuTime
        }

        
        // 1. Add Document to groups collection
        let documentRef = try await impromptuCollection.addDocument(data: data)
        
        // 2. Update the group id from the document reference after t
        try await documentRef.updateData( [Impromptu.CodingKeys.ImpromptuId.rawValue: documentRef.documentID] )
        
        /*
        // 3. Add group to the group member's document
        //try await UserManager.shared.userDocument(userId: userId).updateData(createdGroupId)
        if let members = groupData.groupMembers {
            try await addGroupToMembersDoc(groupMembers: members, groupId: documentRef.documentID)
        }
        */
       
        return documentRef.documentID
    }
    
    
    func getImpromptus()  async throws -> [Impromptu] {
        
        var impromptus: [Impromptu] = []
        let querySnapshot = try await impromptuCollection.order(by: Impromptu.CodingKeys.dateCreated.rawValue).limit(to: 10).getDocuments()
        
        for document in querySnapshot.documents{
            let im = try document.data(as: Impromptu.self)
            
            impromptus.append(im)
        }
        
        return impromptus
    }
    
    
    func updateImpromptuImagePath(impromptuId: String, path: String?, url: String?) async throws {
          
            let data: [String:Any] = [
                Impromptu.CodingKeys.ImpromptuImagePath.rawValue : path as Any,
                Impromptu.CodingKeys.ImpromptuImageUrl.rawValue : url as Any,
            ]
            
            try await ImpromptuDocument(impromtuId: impromptuId).updateData(data)
        }
    
    
    
}
