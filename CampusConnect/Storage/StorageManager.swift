//
//  StorageManager.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/27.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    private func userReference(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }
    
    private func groupReference(groupId: String) -> StorageReference {
        storage.child("groups").child(groupId)
    }
    
    private func meetUpReference(groupId: String) -> StorageReference {
        storage.child("meetups").child(groupId)
    }
    
    func getImagePath(path: String) -> StorageReference{
        Storage.storage().reference(withPath: path)
    }
    
    // Most images are massive in size nowadays
    // It's recommended to resize the images to a specific size before uploading
    // Use Resize Images extension for firebase (paid)
    // TODO: Resize image before uploading to storage
    func saveImage(data: Data, userId: String) async throws -> (path: String, name: String) {
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReference(userId: userId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            //TODO: cutomize error message
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
    func saveImage(image: UIImage, userId: String) async throws -> (path: String, name: String) {
        guard let data = image.jpegData(compressionQuality: 1) else {
            //TODO: cutomize URL error message
            throw URLError(.badURL)
        }
        
        return try await saveImage(data: data, userId: userId)
    }
    
    
    func getImageUrl(path: String) async throws -> URL {
        try await getImagePath(path: path).downloadURL()
    }
    
    func getData(userId: String, path: String) async throws -> Data{
        // Returns data after running the code below
        //try await userReference(userId: userId).child(path).data(maxSize: 3 * 1024 * 1024)
        try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    func getImage(userId: String, path: String) async throws -> UIImage{
        let data = try await getData(userId: userId, path: path)
        
        guard let image = UIImage(data: data) else {
            print("Error: Unable to to convert data to UIImage")
            //TODO: cutomize URL error message
            throw URLError(.badServerResponse)
        }
        
       return image
    }
    
    func deleteImage(path: String) async throws{
        try await getImagePath(path: path).delete()
    }
    
    // MARK: - Group Image functions
    
    func saveGroupImage(data: Data, groupId: String) async throws -> (path: String, name: String) {
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await groupReference(groupId: groupId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            //TODO: cutomize error message
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
    
    func saveMeetUpImage(data: Data, groupId: String) async throws -> (path: String, name: String) {
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await meetUpReference(groupId: groupId).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            //TODO: cutomize error message
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
   
    
}
