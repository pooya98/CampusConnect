//
//  Extensions.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/02.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


// MARK: - Generic Fetch function
// Use generic to fetch all documents
// The generic function gets any document of type T  and returns [T]
extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({document in
            try document.data(as: T.self)
        })
        
    }
    
}



extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


struct RoundedCorner : Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}


