//
//  EnumModels.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/18.
//

import Foundation

enum Department: String, CaseIterable, Identifiable{
    case none = "none"
    case computerScience = "Computer Science"
    case mobileEng = "Mobile Engineering"
    case electronicEng = "Electronic Engineering"
    case electricalEng = "Electrical Engineering"
    
    // NOTE: Enum case without associated value conforms to Hashable by default. We can use self as an id.
    var id: Self { self }
}
