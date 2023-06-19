//
//  ImpromptuModel.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/06/19.
//

import Foundation

struct Impromptu: Codable {
    var ImpromptuId: String?
    let ImpromptuName: String?
    let ImpromptuAdminId: String?
    var ImpromptuImageUrl: String?
    var ImpromptuImagePath: String?
    let ImpromptuLocation: String?
    let ImpromptuTime: String?
    let dateCreated: Date
    
    
    enum CodingKeys: String, CodingKey {
        case ImpromptuId = "impromptu_id"
        case ImpromptuName = "impromptu_name"
        case ImpromptuAdminId = "impromptu_admin_id"
        case ImpromptuImageUrl = "impromptu_iamge_url"
        case ImpromptuImagePath = "impromptu_iamge_path"
        case ImpromptuLocation = "impromptu_location"
        case ImpromptuTime = "impromptu_time"
        case dateCreated = "dateCreated"
    }
}
