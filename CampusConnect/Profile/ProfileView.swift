//
//  ProfileView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/05.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published var newEmail = ""
    
    /*func loadCurrentUser() async throws {
        let authDataResult = try await AuthenticationManager.shared.getAuthenticatedUser()
    }*/
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }

    // TODO: implement UI to get new email address that should be set after editing currrent email
    // NOTE: remember to reauthenticate user before updating email
    // get value from user input
    func updateEmail (email: String) async throws {
        try await AuthenticationManager.shared.updateEmail(email: email)
    }

    
}

struct ProfileView: View {
    
    @StateObject private var profileViewModel =  ProfileViewModel()
    
    var body: some View {
        List {
            if let user = profileViewModel.user {
                Text("UserId: \(user.userId)")
                
                if let userEmail = user.email {
                    Text("Email: \(userEmail)")
                }
            }
            
        }
        .task {
            try? await profileViewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ProfileView()
        }
        
    }
}
