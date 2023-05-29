//
//  ProfileView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/05.
//

import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published var newEmail = ""
    //@Published var profileImage: Image? = nil
    
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
    @Binding var showLoginView: Bool
    @State private var selectedPhoto: PhotosPickerItem?  = nil
    @State private var url: URL? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading)  {
                NavigationLink {
                    EditProfileView()
                } label: {
                    ProfileHeaderSection
                }
                
                
                List {
                    NavigationLink {
                        FriendListView()
                    } label: {
                        Text("Friends")
                    }
                    
                }
                
            }
            .toolbar {  // New in  iOS 16
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddFriendView()
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(showLoginView: $showLoginView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
            }
            .task {
                try? await profileViewModel.loadCurrentUser()
            }
            .navigationTitle("Profile")
            //.navigationBarTitleDisplayMode(.inline)
        }
       
        
        
    }
}

extension ProfileView {
    
    private var ProfileHeaderSection: some View {
        HStack {
            
            // Load Profile image
            if let urlString = profileViewModel.user?.profileImageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    
                    ProfileHeaderView(name: "Herbert", department: "컴퓨터학부", studentId: "2020110876", image: image)
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
                
            }else {
                ProfileHeaderView(name: "Herbert", department: "컴퓨터학부", studentId: "2020110876")
            }
            
        }
        .padding()
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showLoginView: .constant(false))
        //RootView()
    }
}
