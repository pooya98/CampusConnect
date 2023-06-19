//
//  FriendListView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/29.
//

import SwiftUI

@MainActor
class FriendListViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var friendList: [DBUser] = []
    //@Published var selectedFriend: DBUser? = nil
    @Published var groupId: String? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    
    func getFriendList() async throws -> [DBUser]? {
        guard let currentUser = user else {
            print("Error fetching friend list. User is not logged in!")
            return nil
        }
        return try await UserManager.shared.getFiendsList(friendList: currentUser.friendList ?? [])
    }
    
    func getGroupId(seekedUserId: String, seekedUserName: String?)  async throws  -> String? {
        guard let currentUser = user else {
            print("Error fetching friend list. User is not logged in!")
            return nil
        }
        
        var group: (isPresent: Bool, groupId: String?) = (false, nil)
        
        let seekedUserGroup = try await ChatManager.shared.groupExists(adminId: seekedUserId, memberId: currentUser.userId)
        
        let currentUserGroup = try await ChatManager.shared.groupExists(adminId: currentUser.userId, memberId: seekedUserId)
        
        if (currentUserGroup.isPresent) {
            group = currentUserGroup
            print("groupId: \(String(describing: group.groupId))")
        }
        else if(seekedUserGroup.isPresent) {
            group = seekedUserGroup
            print("groupId: \(String(describing: group.groupId))")
        }
        else {
            print("groupId: \(String(describing: group.groupId))")
        }
       
        print("Group exists: \(group.isPresent)")
        
        if(group.isPresent) {
            print("New chat room not created!")
            print("Using existing chat room...")
            return group.groupId
        }
        else {
            let groupData = ChatGroup(groupMembers: [currentUser.userId, seekedUserId], groupType: GroupType.twoPerson.rawValue, displayName: [seekedUserName ?? ""])
            
            let newGroupId = try await ChatManager.shared.createChatGroup(groupData: groupData)
            print("Created new chat room!")
            return newGroupId
            
        }
    }
    
    func setGroupId(friendList: [DBUser]?) async throws {
        
        if var friends = friendList{
            for i in 0..<friends.count {
                print("loading friendList ...")
                if let element = try? await getGroupId(seekedUserId: friends[i].userId, seekedUserName: friends[i].firstName) {
                    
                    friends[i].groups?[0] = element
                }
                
            }
            self.friendList = friends
        }
        
    }
    
    
}

struct FriendListView: View {
    @StateObject private var friendListViewModel = FriendListViewModel()
    @State private var showChatRoom = false
    
    
    
    var body: some View {
        
        VStack {
            if(friendListViewModel.friendList.isEmpty) {
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
                        ForEach(friendListViewModel.friendList, id: \.userId) { friend in
                            
                            NavigationLink {
                                // MARK: - TODO
                                // TODO: handle cases where group id is nill
                                ChatThreadView(groupId: friend.groups?.first ?? "lG6CpNumnRMTjyny3755", profileImageUrl: friend.profileImageUrl, name: friend.firstName)
                                
                            } label: {
                                FriendTagView(name: friend.firstName ?? "Anonymous Friend", department: "컴퓨터학부", profilePicUrl: friend.profileImageUrl)
                            }

                        }
                    }
                    
                }
            }
        }
        .task {
            // MARK: - TODO
            // TODO: Add a loading screeen
            print("Loading currentuser data in friend list view...")
            try? await friendListViewModel.loadCurrentUser()
            print("Loading complete!")
            
            print("Fetching friend list...")
            let tempFriendlist = try? await friendListViewModel.getFriendList()
            print("Fetching fcomplete!")
            
            print("Adding group id to friend list elemnts...")
            try? await friendListViewModel.setGroupId(friendList: tempFriendlist)
            print("Adding group id Complete...")
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
