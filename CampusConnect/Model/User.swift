//
//  User.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/26.
//

import Foundation

struct User {
    let id: UUID = UUID()
    let firebaseID: String
    let firstName: String
    let lastName: String
    let imageURL: String
    let region: String
}


let OtherUserSamples = [
    User(firebaseID: "a1234", firstName: "herbert", lastName: "Okuthe", imageURL: "DefaultUserImage", region: "테크노문"),
    User(firebaseID: "b1234", firstName: "Seungwoo", lastName: "Kang", imageURL: "DefaultUserImage",region:"북문"),
    User(firebaseID: "c1234", firstName: "Hungyu", lastName: "Lee", imageURL: "DefaultUserImage", region:"동문")
]

let CurrentUser = User(firebaseID: "m1234", firstName: "Seungwoo", lastName: "Kang", imageURL: "DefaultUserImage",region:"테크노문")
