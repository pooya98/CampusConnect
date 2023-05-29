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
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func getFriendList() async throws {
        try await loadCurrentUser()
        
        // Ensure that currentUser has a value
        guard let user else { return }
        
        for friend in user.friendList ?? [] {
            print(friend)
        }
        
        try await loadCurrentUser()
    }
    
    
}

struct FriendListView: View {
    @StateObject private var friendListViewModel = FriendListViewModel()
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                FriendTag
                
                Button {
                    /*Task {
                        try await friendListViewModel.getFriendList()
                    }*/
                    
                    print("function executed")
                } label: {
                    Text("Get List")
                }

            }
            
            List {
                /*ForEach(friendListViewModel.user?.friendList ?? [], id: \.self) { friendId in
                    Text(friendId.lowercased())
                }*/
            }
            
            
        }
        .task {
            try? await friendListViewModel.loadCurrentUser()
            
        }
        .padding()
        //.frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color("AliceBlue"))
        .navigationTitle("Friends")
    }
}


extension FriendListView {
    
    private var FriendTag: some View {
        VStack(alignment: .leading) {
            HStack() {
                ProfileAvatarView(personSize: 40, frameSize: 60)
                
                VStack(alignment: .leading) {
                    Text("Herbert")
                        .fontWeight(.bold)
                        .font(.subheadline)
                    
                    Text(".컴푸터학부")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
            }
            
        }
        //.padding()
        //.frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color("AliceBlue"))
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FriendListView()
        }
        
    }
}
