//
//  UserManager.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    
    // singleton design pattern
    static let shared = UserManager()
    private init() { }
    
    let userCollection = Firestore.firestore().collection("users")
    
    func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    
   /* private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()*/
    
    /*private let dencoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()*/
    
    // Write Data Method 1: utilizes Codable protocol
    // TODO: Implement a working createNewUser funtion that ulitizes Codable
    // ------------ NOT WOKING ------------
    // async function not available at time of creation
    
     /*func createNewUser(user: DBUser) throws {
        //try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
        
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
        print("UserData set")
        print("userId: \(user.userId)")
     }*/
    
    // ------------ END NOT WOKING ------------
    
    // Write Data Method 2: hard code key and value
    func createNewUser(authData: AuthDataResultModel, registrationDetails: AccountRegistrationDetails) async throws {
        var userData : [String: Any] = [
            DBUser.CodingKeys.userId.rawValue : authData.uid,
            DBUser.CodingKeys.dateCreated.rawValue : Timestamp() // from firebase SDK
        ]
        

        if let email = authData.email {
            userData[DBUser.CodingKeys.email.rawValue] = email
        }
        
        if let photoUrl = authData.photoUrl {
            userData[DBUser.CodingKeys.photoUrl.rawValue] = photoUrl
        }
        
        if let firstName = registrationDetails.firstName {
            userData[DBUser.CodingKeys.firstName.rawValue] = firstName
        }
        
        if let lastName = registrationDetails.lastName {
            userData[DBUser.CodingKeys.lastName.rawValue] = lastName
        }
        
        try await userDocument(userId: authData.uid).setData(userData)
    }
    
    
    // Fetch Data Method 2: utilize Codable protocol
    /*func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: dencoder)
    }*/
    
    func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    // Fetch Data Method 2: hard coded
    /*func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await userDocument(userId: userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else { // userId should aleays have a value
            // TODO: create custom error message
            throw URLError(.badServerResponse)
        }
        
        let firstName = data["first_name"] as? String
        let lastName = data["last_name"] as? String
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        
        return DBUser(userId: userId, firstName: firstName, lastName: lastName, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    }*/
    
    
    // Query database to get back a list of users with a specified email
    // Typically returns an array with one user
    
    // Method 1. to get users
    func getUser(email: String)  async throws -> [DBUser] {
     
        var matchingUsers: [DBUser] = []
        
        let querySnapshot = try await userCollection.whereField(DBUser.CodingKeys.email.rawValue, isEqualTo: email).getDocuments()
        
        for document in querySnapshot.documents {
            
            let user = try document.data(as: DBUser.self)
            matchingUsers.append(user)
        }
        
        return matchingUsers
    }
    
    // Method 2. fetch users from the firestore
    /*func getUser(email: String)  async throws -> [DBUser] {
        return try await userCollection.whereField("email", isEqualTo: email).getDocuments(as: DBUser.self)
    }*/
    
    
    func deleteUserData(userId: String) async throws{
        try await Firestore.firestore().collection("users").document(userId).delete()
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
     
        let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path as Any,
            DBUser.CodingKeys.profileImageUrl.rawValue : url as Any,
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
   
    func addFriend(userId: String, friendId: String) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.friendList.rawValue : FieldValue.arrayUnion([friendId]) // appends new values to the current array
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    
    func checkFriendExists(userId: String, friendId: String) async throws -> Bool {
        
        // The query contains a single document since userId is unique
        let querySnapshot = try await userCollection
            .whereField(DBUser.CodingKeys.userId.rawValue, isEqualTo: userId)
            .whereField(DBUser.CodingKeys.friendList.rawValue, arrayContains: friendId).getDocuments()
        
        for document in querySnapshot.documents {
            let returnedUser = try document.data(as: DBUser.self)
            
            if returnedUser.userId == userId{
                return true
            }
        }
        
        return false
    }
    
    
    func getFiendsList(friendList: [String]) async throws -> [DBUser] {
        var groups: [DBUser] = []
        
        let querySnapshot = try await userCollection.whereField(DBUser.CodingKeys.userId.rawValue, in: friendList).getDocuments()
        
        for document in querySnapshot.documents{
            let group = try document.data(as: DBUser.self)
            
            groups.append(group)
        }
        
        return groups
    }
    
}


