//
//  AddFriendView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/28.
//

import SwiftUI
//import AlertToast



@MainActor
final class AddFriendViewModel: ObservableObject {
    @Published private(set) var seekedUser: DBUser? = nil
    @Published private(set) var currentUser: DBUser? = nil
    @Published var emailID: String  = ""
    @Published var matchFound: Bool = false
    @Published var accountOwner: Bool = false
    @Published var friend: Bool = false
    @Published var showResultsNotFound = false
    //@Published var groupMessages: [Message]? = nil
    @Published var groupId: String? = nil
    
    
    
    // MARK: - Create Group
    // Checks whether groups exists before creating a group
    
    // How it works
    // 1. Find an group which the seekedUser created or is the admin
    // 2. If the group doesn't exist create a new group with currentUser(group creator) assigned as the admin and load groupId
    // 3. If it exists laod groupId and skip group creation
    
    func createGroup(currentUserId: String, seekedUserId: String, displayName: String) async throws {
        
        var group: (isPresent: Bool, groupId: String?) = (false, nil)
        
        let seekedUserGroup = try await ChatManager.shared.groupExists(adminId: seekedUserId, memberId: currentUserId)
        
        let currentUserGroup = try await ChatManager.shared.groupExists(adminId: currentUserId, memberId: seekedUserId)
        
        if (currentUserGroup.isPresent) {
            group = currentUserGroup
            print("groupId: ", group.groupId as Any)
        }
        else if(seekedUserGroup.isPresent) {
            group = seekedUserGroup
            print("groupId: ", group.groupId as Any)
        }
        else {
            print("groupId: ", group.groupId as Any)
        }
       
        
        self.groupId = group.groupId
        
        print("Group exists: \(group.isPresent)")
        
        if(!group.isPresent) {
            
            let groupData = ChatGroup(groupMembers: [currentUserId, seekedUserId], groupType: GroupType.twoPerson.rawValue, displayName: [displayName])
                
            self.groupId = try await ChatManager.shared.createChatGroup(groupData: groupData)
            print("Created new chat room!")
        }
        else {
            print("New chat room not created!")
            print("Using existing chat room...")
        }
    }
    
   
    // MARK: - Find User
    
    // NOTE: cases where 2 users are friends but don't have a two-person group(chat room) can exist because a user might choose to exit the already established group(chat room)
    // 1 . A new group(chat room) will be established automatically when current user searches for an already existing friend and no prior two-person group exists where the current user and seeked user are members
    // That is a group which the currentUser created or the seekedUser created and the currentuser is memeber don't exist
    
    func findUser() async throws {
        
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.currentUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        // Only one user is appended to the array since email is unique to every user
        let userlist:[DBUser] = try await UserManager.shared.getUser(email: emailID)
        
        //print(userlist)
        
        seekedUser = userlist.first
        
        matchFound = userlist.isEmpty  ? false : true
        showResultsNotFound = matchFound == true ? false : true
        
        // Ensure that currentUser has a value
        guard let currentUser else { return }
        
        // Ensure that seekedUser has a value
        guard let seekedUser else { return }
        
        accountOwner = seekedUser.userId == currentUser.userId ? true : false
        friend = try await UserManager.shared.checkFriendExists(userId: currentUser.userId, friendId: seekedUser.userId)
        
        print("friend of current user: ",friend)
        
        // MARK: - Find User And Create Group
        
        if(friend) {
            try await createGroup(currentUserId: currentUser.userId, seekedUserId: seekedUser.userId, displayName: seekedUser.firstName ?? "")
            
        // MARK: - Load Messages
            // try await loadMessages()
        }
    }
    
    
    // MARK: - Add Friend
    
    // NOTE: cases where a user belongs to a group(chat room) but isn't a friend of the the group's(chat room's) creator occurs when when the group's creator adds a non friend to the friend's list
    // Adding a friend will automatically create a two-person group(chat room), assign the group's creator as admin and add both the admin and the newly added friend to the group
    
    func addFriend() async throws {
        
        // Ensure that currentUser has a value
        guard let currentUser else { return }
        // Ensure that seekedUser has a value
        guard let seekedUser else { return }
        
        // Add to friend List
        try await UserManager.shared.addFriend(userId: currentUser.userId, friendId: seekedUser.userId)
        print("Added \(seekedUser.firstName ?? "matched user")")
        
        
        // MARK: - Add Friend And Create Group
        
        try await createGroup(currentUserId: currentUser.userId, seekedUserId: seekedUser.userId, displayName: seekedUser.firstName ?? "")
        
        // Refetch data to appear on the screen
    }
    
    // get all messages from the group
    // TODO: Add an error message when user can load messages
    /*func loadMessages() async throws {
        
        guard let grupId = groupId else {
            print("Cant access the group")
            return
        }
        self.groupMessages = try await ChatManager.shared.getMessages(groupId: grupId)
        print("Messages: ", groupMessages as Any)
    }*/
    
    
    
    
}

struct AddFriendView: View {
    
    @StateObject var addFriendViewModel = AddFriendViewModel()
    @State var okButtonDisabled = true
    @State var addFriendButtonDisabled = false
    @State private var showLoading = false
    @State private var showChatRoom = false
    
    
    var body: some View {
        VStack{
            
            TextField("Campus Connect Email", text: $addFriendViewModel.emailID)
                .autocapitalization(.none)
                .textCase(.lowercase)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .onChange(of: addFriendViewModel.emailID) { newValue in
                    if (newValue != "") {
                        okButtonDisabled = false
                    }
                    else {
                        okButtonDisabled = true
                    }
                }
               
            // MARK: - TODO
            // TODO: Add progress spinner
            Button {
                Task{
                    // MARK: - TODO
                    // TODO: use a do catch  to capture the error
                    try await addFriendViewModel.findUser()
                    
                    if(!addFriendViewModel.accountOwner && !addFriendViewModel.friend) {
                        print("New Friend: true.....this section")
                        if(addFriendButtonDisabled){
                            addFriendButtonDisabled = false
                            
                        }
                    }
                    
                }
                
                // Enable add friend button when user finds an new friend
                //addFriendButtonDisabled = false
                
                
            } label: {
                if okButtonDisabled {
                    Text("SEARCH")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.9))
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.9))
                        .cornerRadius(10)
                }else{
                    Text("SEARCH")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.top, 20)
            .disabled(okButtonDisabled)
            
            VStack{
                if (addFriendViewModel.showResultsNotFound) {
                    Text("No results found")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                }
                
                // MARK: - ISSUE
                // When a friend is found it displays add friend label for  a brief moment then the message label is displayed.
                // This occurs when a serach is performed immediately afer the page is opened
                if(addFriendViewModel.matchFound) {
                    
                    // Display profile picture
                    ProfileAvatarView(profilePicUrl: addFriendViewModel.seekedUser?.profileImageUrl, personSize: 80, frameSize: 100)
                    
                    // Display user name
                    Text(addFriendViewModel.seekedUser?.firstName ?? "matching user")
                    
                    // MARK: - TODO
                    
                    // Display different button labels based on:
                    // 1: match found is current User(account owner)
                    // 2: match found already exits in user's friend list
                    // 3: friend not in user's friend list
                    // TODO: add button action for all the labels
                    if(addFriendViewModel.accountOwner) {
                        // Display my profile
                        Button {
                            
                        } label: {
                            Text("My Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: 150)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                    }
                    else if (addFriendViewModel.friend) {
                                                
                        NavigationLink {
                            
                            // TODO: handle cases with nil as input 
                            ChatThreadView(groupId: addFriendViewModel.groupId ?? "lG6CpNumnRMTjyny3755",profileImageUrl: addFriendViewModel.seekedUser?.profileImageUrl, name: addFriendViewModel.seekedUser?.firstName//, messages: addFriendViewModel.groupMessages ?? []
                            )
                            
                            //ChatThreadView(messages: <#T##[Message]#>)
                            
                        } label: {
                            // Display chat room when clicked
                            Text("Message")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: 150)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                    }
                    else {
                        // TODO: Add Alert (Complete)
                        // Add Friend to friend list
                        Button {
                            
                            
                            // MARK: - TODO
                            // TODO: Add progress spinner
                            
                            showLoading.toggle()
                            Task {
                                
                                // MARK: - TODO
                                // TODO: Use a do catch to capture error
                                try await addFriendViewModel.addFriend()
                                
                                // Disables button after friend is added to the friend list
                                // A disalbed button is enabled when search button is pressed is pressed
                                addFriendButtonDisabled = true
                                
                            }
                            showLoading.toggle()
                            
                            // MARK: - Friend Added Toast
                            
                        } label: {
                            // Disabled button
                            if (addFriendButtonDisabled) {
                                Text("Add Friend")
                                    .font(.headline)
                                    .foregroundColor(.black.opacity(0.9))
                                    .frame(height: 55)
                                    .frame(maxWidth: 150)
                                    .background(Color.gray.opacity(0.9))
                                    .cornerRadius(10)
                                
                            }else {
                                // Enabled button
                                Text("Add Friend")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: 150)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .disabled(addFriendButtonDisabled)
                        
                    }
                    
                    
                    /*Button {
                        
                        // Display Profile page
                        if(addFriendViewModel.accountOwner) {
                            
                        }
                        else if (addFriendViewModel.friend) {
                            // Display chat room
                            showChatRoom = true
                            
                        }else {
                            // MARK: - TODO
                            // TODO: Add progress spinner
                            
                            showLoading.toggle()
                            Task {
                                try await addFriendViewModel.addFriend()
                                
                                // Disables button after friend is added to the friend list
                                addFriendButtonDisabled = true
                            }
                            showLoading.toggle()
                            
                            // MARK: - Friend Added Toast
                        }
                        
                    } label: {
                        if(addFriendViewModel.accountOwner) {
                            Text("My Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: 150)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        if(addFriendViewModel.friend) {
                            Text("Message")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: 150)
                                .background(Color.blue)
                                .cornerRadius(10)
                            
                        }
                        
                        if(!addFriendViewModel.accountOwner && !addFriendViewModel.friend) {
                            
                            // Disableed button
                            if (addFriendButtonDisabled) {
                                Text("Add Friend")
                                    .font(.headline)
                                    .foregroundColor(.black.opacity(0.9))
                                    .frame(height: 55)
                                    .frame(maxWidth: 150)
                                    .background(Color.gray.opacity(0.9))
                                    .cornerRadius(10)
                                
                            }else {
                                // Enabled button
                                Text("Add Friend")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: 150)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                        }
                    }.disabled(addFriendButtonDisabled)*/

                }
                
            }
            .padding(.top, 70)
            /*.fullScreenCover(isPresented: $showChatRoom) {
                ChatThreadView(showChatRoom: $showChatRoom, profileImageUrl: addFriendViewModel.seekedUser?.profileImageUrl, name: addFriendViewModel.seekedUser?.firstName)
                
            }
            */
//            .toast(isPresenting: showLoading) {
//                AlertToast(type: .loading)
//            }

           
            Spacer()
            
            
        }
        .navigationTitle("Add Friend").padding(.top, 30)
        .padding()
        
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddFriendView()
        }
        
    }
}
