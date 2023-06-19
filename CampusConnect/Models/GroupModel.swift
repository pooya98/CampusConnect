//
//  GroupModel.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/06/17.
//

import Foundation

struct MyGroup: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var memberCount: Int
    var isRegular: Bool
    var meetingDay: String
    var meetingTime: String
    var imageName: String
    var location: String
    var category: String
}
