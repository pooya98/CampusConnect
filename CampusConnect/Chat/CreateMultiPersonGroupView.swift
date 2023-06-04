//
//  CreateMultiPersonGroupView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/03.
//

import SwiftUI

@MainActor
final class CreateMultiPersonGroupViewModel: ObservableObject{
    //@Published var selectedFriends = Set<DBUser>()
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var friendList: [DBUser] = []
    @Published var selectedFriends: [DBUser] = []
    //@Published var addedMemebrIds: [String] = []
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    
    func getFriendList() async throws {
        guard let currentUser = user else {
            print("Error fetching friend list. User is not logged in!")
            return
        }
        self.friendList =  try await UserManager.shared.getFiendsList(friendList: currentUser.friendList ?? [])
    }
    
    func getGroupMembers() -> [String] {
        var members: [String] = []
        
        guard let currentUser = user else {
            print("Error fetching friend list. User is not logged in!")
            return []
        }
       
        members.append(currentUser.userId)
        for friend in selectedFriends {
            members.append(friend.userId)
        }
        // reset selected friends
        //selectedFriends = []
        return members
    }
    
}

struct CreateMultiPersonGroupView: View {
    
    @StateObject private var createMultiPersonGroupViewModel = CreateMultiPersonGroupViewModel()
    @State var selected = false
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack(){
                        Spacer()
                        
                        
                        if(createMultiPersonGroupViewModel.selectedFriends.count >= 2) {
                            NavigationLink {
                                GroupChatDetailsView(groupChatMembers: createMultiPersonGroupViewModel.getGroupMembers())
                               
                            } label: {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.largeTitle)
                                    .fontWeight(.medium)
                                    .padding(.trailing, 10)
                                //.resizable()
                                //.frame(width: 30, height: 30)
                                
                            }
                            
                        }
                        else {
                            Image(systemName: "arrow.right.circle.fill")
                                .padding(.trailing, 10)
                                .font(.largeTitle)
                                //.frame(width: 30, height: 30)
                                .foregroundColor(.gray.opacity(0.3))
                        }
                       
                    }

                        
                    
                    
                    
                    if(!createMultiPersonGroupViewModel.selectedFriends.isEmpty) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 20){
                                /*ProfileAvatarView(personSize: 40, frameSize: 60)
                                ProfileAvatarView(personSize: 40, frameSize: 60)
                                ProfileAvatarView(personSize: 40, frameSize: 60)
                                ProfileAvatarView(personSize: 40, frameSize: 60)
                                ProfileAvatarView(personSize: 40, frameSize: 60)
                                ProfileAvatarView(personSize: 40, frameSize: 60)*/
                                ForEach(createMultiPersonGroupViewModel.selectedFriends, id: \.userId) { friend in
                                    VStack{
                                        ProfileAvatarView(profilePicUrl: friend.profileImageUrl,personSize: 40, frameSize: 60)
                                        
                                        Text(friend.firstName ?? "Anonymous")
                                            .foregroundColor(.black)
                                            .font(.caption)
                                    }
                                    
                                }
                                
                            }
                           
                        }
                        .padding(.horizontal, 5)
                        .scrollIndicators(.hidden)
                        
                    }
                    
                    
                }
                //.frame(maxWidth: .infinity, maxHeight: 100)
                //.background(Color("PlumWeb"))
            
                VStack(alignment: .leading) {
                        List {
                            /*
                            Text("Add participants")
                                .padding()
                                .font(.footnote)
                                .fontWeight(.bold)
                            Text("Add participants")
                                .padding()
                                .font(.footnote)
                                .fontWeight(.bold)
                            */
                            ForEach(createMultiPersonGroupViewModel.friendList, id: \.userId) { friend in
                                
                                HStack {
                                    FriendTagView(name: friend.firstName ?? "Anonymous Friend", department: "컴퓨터학부", profilePicUrl: friend.profileImageUrl)
                                    
                                    Spacer()
                                    
                                    Button {
                                        
                                        if(createMultiPersonGroupViewModel.selectedFriends.contains(friend)) {
                                            
                                            if let index = createMultiPersonGroupViewModel.selectedFriends.firstIndex(of: friend) {
                                                createMultiPersonGroupViewModel.selectedFriends.remove(at: index)
                                            }
                                                
                                           
                                            print("selected removed: \(String(describing: friend.firstName))")
                                        }
                                        else {
                                            createMultiPersonGroupViewModel.selectedFriends.append(friend)
                                            print("selected added: \(String(describing: friend.firstName))")
                                        }
                                        
                                        print("Seleted List: \(createMultiPersonGroupViewModel.selectedFriends)")
                                        
                                    } label: {
                                        
                                        if(createMultiPersonGroupViewModel.selectedFriends.contains(friend)) {
                                            Image(systemName: "circle.fill")
                                                .imageScale(.large)
                                                .foregroundColor(Color("SelectGreen"))
                                                .frame(width: 32, height: 32)
                                        }else {
                                            Image(systemName: "circle")
                                                .imageScale(.large)
                                                .foregroundColor(Color("SelectGreen"))
                                                .frame(width: 32, height: 32)
                                        }
                                    }
                                }

                            }
                            
                        }
                        .padding(.top, 5)
                        
                }
                
            }
            //.background(Color("SmithApple"))
            //.background(Color("BackgroundGray"))
            
        }
        .navigationTitle("Add Group participants")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // MARK: - TODO
            // TODO: Add a loading screeen
            print("Loading currentuser data in friend list view...")
            try? await createMultiPersonGroupViewModel.loadCurrentUser()
            print("Loading complete!")
            
            print("Fetching friend list...")
            try? await createMultiPersonGroupViewModel.getFriendList()
            print("Fetching fcomplete!")
            
            /*print("Adding group id to friend list elemnts...")
            try? await createMultiPersonGroupViewModel.setGroupId(friendList: tempFriendlist)
            print("Adding group id Complete...")*/
        }
        
       
       
    }
}

struct CreateMultiPersonGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CreateMultiPersonGroupView()
        }
        
    }
}
