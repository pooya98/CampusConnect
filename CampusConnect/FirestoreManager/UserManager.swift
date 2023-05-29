//
//  UserManager.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    //let id: UUID // to confirm to type Identifiable
    let userId: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let profileImageUrl: String?
    let profileImagePath: String?
    let friendList: [String]?
    //let isActive: Bool = true
    
    // TODO: Create CodingKeys
    
    init(authData: AuthDataResultModel, accountDetails: AccountRegistrationDetails) {
        //self.id = UUID()
        self.userId = authData.uid
        self.firstName = accountDetails.firstName
        self.lastName = accountDetails.lastName
        self.email = authData.email
        self.photoUrl = authData.photoUrl
        self.dateCreated = Date()
        self.profileImageUrl = nil
        self.profileImagePath = nil
        self.friendList =  nil
    }
    
}

final class UserManager {
    
    // singleton design pattern
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let dencoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // Write Data Method 1: utilizes Codable protocol
    // TODO: Implement a working createNewUser funtion that ulitizes Codable
    // ------------ NOT WOKING ------------
    // async function not available at time of creation
    /*
     func createNewUser(user: DBUser) throws {
        //try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
        
        
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
        print("UserData set")
        print("userId: \(user.userId)")
     }
    */
    // ------------ END NOT WOKING ------------
    
    // Write Data Method 2: hard code key and value
    func createNewUser(authData: AuthDataResultModel, registrationDetails: AccountRegistrationDetails) async throws {
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
        
        if let firstName = registrationDetails.firstName {
            userData["first_name"] = firstName
        }
        
        if let lastName = registrationDetails.lastName {
            userData["last_name"] = lastName
        }
        
        try await userDocument(userId: authData.uid).setData(userData, merge: false)
    }
    
    
    // Fetch Data Method 2: utilize Codable protocol
    func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: dencoder)
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
    func getUser(email: String)  async throws -> [DBUser] {
     
        var matchingUsers: [DBUser] = []
        
        let querySnapshot = try await userCollection.whereField("email", isEqualTo: email).getDocuments()
        
        for document in querySnapshot.documents {
            
            let user = try document.data(as: DBUser.self, decoder: dencoder)
            matchingUsers.append(user)
        }
        
        return matchingUsers
    }
    
    
    func deleteUserData(userId: String) async throws{
        try await Firestore.firestore().collection("users").document(userId).delete()
    }
    
    func updateUserProfileImagePath(userId: String, path: String?, url: String?) async throws {
        // Use after defining CodingKeys
        /*
         let data: [String:Any] = [
            DBUser.CodingKeys.profileImagePath.rawValue : path
        ]
         */
        
        let data: [String:Any] = [
            "profile_image_path" : path as Any,
            "profile_image_url" : url as Any,
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
   
    func addFriend(userId: String, friendId: String) async throws {
        let data: [String:Any] = [
            "friend_list" : FieldValue.arrayUnion([friendId]) // appends new values to the current array
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    
    func checkFriendExists(userId: String, friendId: String) async throws -> Bool {
        
        // the query contains a single document since userId is unique
        let querySnapshot = try await userCollection
            .whereField("user_id", isEqualTo: userId)
            .whereField("friend_list", arrayContains: friendId).getDocuments()
        
        for document in querySnapshot.documents {
            let returnedUser = try document.data(as: DBUser.self, decoder: dencoder)
            
            if returnedUser.userId == userId{
                return true
            }
        }
        
        return false
    }
}
