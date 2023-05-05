//
//  UserManager.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    
    let userId: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    
}

final class UserManager {
    
    //singleton design pattern
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(authData: AuthDataResultModel, userDetails: UserDetails) async throws {
        var userData : [String:Any] = [
            "user_id": authData.uid,
            "date_created" : Timestamp() // from firebase SDK
        ]
        

        if let email = authData.email {
            userData["email"] = email
        }
        
        if let photoUrl = authData.photoUrl {
            userData["photo_url"] = photoUrl
        }
        
        if let firstName = userDetails.firstName {
            userData["first_name"] = firstName
        }
        
        if let lastName = userDetails.lastName {
            userData["last_name"] = lastName
        }
        
        
        try await Firestore.firestore().collection("users").document(authData.uid).setData(userData, merge: false)
    }
    
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else { // userId should aleays have a value
            throw URLError(.badServerResponse)
        }
        
        let firstName = data["first_name"] as? String
        let lastName = data["last_name"] as? String
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        
        return DBUser(userId: userId, firstName: firstName, lastName: lastName, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    }
}
