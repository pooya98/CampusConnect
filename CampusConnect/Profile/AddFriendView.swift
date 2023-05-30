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
    
    func findUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.currentUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        // Only one user is appended to the array since email is unique to every user
        let userlist:[DBUser] = try await UserManager.shared.getUser(email: emailID)
        
        seekedUser = userlist.first
        
        matchFound = userlist.isEmpty  ? false : true
        showResultsNotFound = matchFound == true ? false : true
        
        // Ensure that currentUser has a value
        guard let currentUser else { return }
        // Ensure that seekedUser has a value
        guard let seekedUser else { return }
        
        accountOwner = seekedUser.userId == currentUser.userId ? true : false
        friend = try await UserManager.shared.checkFriendExists(userId: currentUser.userId, friendId: seekedUser.userId)
    }
    
    
    func addFriend() async throws {
        // let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        // let currentUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
        // Ensure that currentUser has a value
        guard let currentUser else { return }
        // Ensure that seekedUser has a value
        guard let seekedUser else { return }
        
        // Add to friend List
        try await UserManager.shared.addFriend(userId: currentUser.userId, friendId: seekedUser.userId)
        print("Added \(seekedUser.firstName ?? "matched user")")
        
        // MARK: - Create Group
        
        
        let groupData = ChatGroup(groupMembers: [currentUser.userId, seekedUser.userId])
            
        try await ChatManager.shared.createChatGroup(groupData: groupData)
        print("Created chat room")
        
        
        
        // Refetch data to appear on the screen
        
    }
    
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
               
            
            Button {
                Task{
                    try await addFriendViewModel.findUser()
                }
                
            } label: {
                if okButtonDisabled {
                    Text("OK")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.9))
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.9))
                        .cornerRadius(10)
                }else{
                    Text("OK")
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
                /*if (addFriendViewModel.showResultsNotFound) {
                    Text("No results found")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                }*/
                
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
                    
                    if (addFriendViewModel.friend) {
                        
                        // Display chat room
                        Button {
                            showChatRoom = true
                        } label: {
                            Text("Message Friend")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: 150)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                        
                        /*print("disabled: 1: \(addFriendButtonDisabled)")
                        addFriendButtonDisabled = false
                        print("disabled: 2: \(addFriendButtonDisabled)")
                        */
                    }
                    
                    if(!addFriendViewModel.accountOwner && !addFriendViewModel.friend) {
                        
                        // Enable button incase it's disabled
                        /*if(addFriendButtonDisabled) {
                            addFriendButtonDisabled = true
                        }*/
                        
                        // Add Friend to friend list
                        Button {
                            
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
                            print("disabled: 1: \(addFriendButtonDisabled)")
                            addFriendButtonDisabled = false
                            print("disabled: 2: \(addFriendButtonDisabled)")
                            
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
                            
                            
                        // Display chat room
                        /*if(addFriendViewModel.friend) {
                            
                            if(addFriendButtonDisabled) {
                                addFriendButtonDisabled = false
                            }
                            
                        }*/
                        
                        
                        // Add friend to friend list
                        /*if (!addFriendViewModel.accountOwner && !addFriendViewModel.friend) {
                            
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
                         */
                        
                        
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
                            Text("Friend")
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
                    }*/

                }
                else {
                    Text("No results found")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                }
                
            }
            .padding(.top, 70)
            .fullScreenCover(isPresented: $showChatRoom) {
                ChatView(showChatRoom: $showChatRoom, profileImageUrl: addFriendViewModel.seekedUser?.profileImageUrl, name: addFriendViewModel.seekedUser?.firstName)
                
            }
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
