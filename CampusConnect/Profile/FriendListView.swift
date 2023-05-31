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
    @Published var selectedFriend: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    
    func getFriendList() async throws {
        //try await loadCurrentUser()
        
        // Ensure that currentUser has a value
        guard let user else { return }
        
        for friend in user.friendList ?? [] {
            
            let result = try await UserManager.shared.getUser(userId: friend)
            self.friends.append(result)
            //print(friends)
        }
        
        //try await loadCurrentUser()
    }
    
    
}

struct FriendListView: View {
    @StateObject private var friendListViewModel = FriendListViewModel()
    @State private var showChatRoom = false
    
    
    
    var body: some View {
        
        VStack {
            if(friendListViewModel.friends.isEmpty) {
                ProfileAvatarView(personSize: 40, frameSize: 60)
                
                // MARK: - ISSUE
                
                // TODO: fix No Friend Added brief display when page is opened
                // Displays briefly before being dissmissed even though user has a friend
                Text("No Friends Added")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
            }
            else {
                
                VStack(alignment: .leading) {
                    List {
                        ForEach(friendListViewModel.friends, id: \.userId) { friend in
                            Button {
                                
                                friendListViewModel.selectedFriend = friend
                                //ChatView(profileImageUrl: friend.profileImageUrl, name: friend.firstName)
                                showChatRoom.toggle()
                            } label: {
                                FriendTagView(name: friend.firstName ?? "Anonymous Friend", department: "컴퓨터학부", profilePicUrl: friend.profileImageUrl)
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showChatRoom) {
                        //ChatView(profileImageUrl: friend.profileImageUrl, name: friend.firstName)
                        //ChatView(showChatRoom: $showChatRoom, profileImageUrl: friend.profileImageUrl, name: friend.firstName)
                        /*ChatView(showChatRoom: $showChatRoom, profileImageUrl: friendListViewModel.selectedFriend?.profileImageUrl, name: friendListViewModel.selectedFriend?.firstName)*/
                        
                    }
                    
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
                //.preferredColorScheme(.dark)
        }
        
    }
}
