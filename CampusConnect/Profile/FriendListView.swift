//
//  FriendListView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/29.
//

import SwiftUI

@MainActor
final class FriendListViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var friends: [DBUser] = []
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    
    func getFriendList() async throws {
        try await loadCurrentUser()
        
        // Ensure that currentUser has a value
        guard let user else { return }
        
        for friend in user.friendList ?? [] {
            
            let result = try await UserManager.shared.getUser(userId: friend)
            self.friends.append(result)
            print(friends)
        }
        
        try await loadCurrentUser()
    }
    
    
}

struct FriendListView: View {
    @StateObject private var friendListViewModel = FriendListViewModel()
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            List {
                ForEach(friendListViewModel.friends, id: \.userId) { friend in
                    FriendTagView(name: friend.firstName ?? "Anonymous Friend", department: "컴퓨터학부", profilePicUrl: friend.profileImageUrl)
                }
            }
            
            
        }
        .task {
            try? await friendListViewModel.loadCurrentUser()
            
            try? await friendListViewModel.getFriendList()
        }
        .padding(.top, 20)
        .navigationTitle("Friends")
    }
}


struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FriendListView()
        }
        
    }
}
