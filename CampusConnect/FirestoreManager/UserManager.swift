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
    
    let userId: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    //let isActive: Bool = true
    
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
        let encode = Firestore.Encoder()
        encode.keyEncodingStrategy = .convertToSnakeCase
        return encode
    }()
    
    // async function not available at time of creation
    func createNewUser(user: DBUser) async throws {
        //try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
        try userDocument(userId: user.userId).setData(from: user, merge: false)
        print("UserData set")
    }
    
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
    
    
    func getUser(userId: String) async throws -> DBUser {
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
    }
    
    func deleteUserData(userId: String) async throws{
        try await Firestore.firestore().collection("users").document(userId).delete()
    }
}
