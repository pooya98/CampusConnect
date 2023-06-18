//
//  ChatView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/28.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class ChatVieModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var groupChats: [ChatGroup] = []
    @Published var displayName: String? = nil
    @Published var profileUrl: String? = nil
    
    func getGroupChats() async throws -> [ChatGroup]? {
        guard let currentUser = user else {
            print("Error. user not logged in")
            return nil
        }
        let groups = try await ChatManager.shared.getGroups(userId: currentUser.userId)
         
        print("Number of groups found: \(groups.count)")
        return groups
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func getProfileImageUrl(userId: String) async throws -> String? {
        let chatMember =  try await UserManager.shared.getUser(userId: userId)
        return chatMember.profileImageUrl
    }
    
    
    func getDisplayImage(chatGroup: ChatGroup) async throws -> String? {
        var profileUrl: String? = nil
        
        if(chatGroup.groupType == GroupType.twoPerson.rawValue) {
            if(user?.userId == chatGroup.groupMembers?.first) {
                
                // get image for member at index one
                guard let memberId = chatGroup.groupMembers?.last else {
                    print("The user ID doesn't exist. User might have exited the chat")
                    return nil
                }
                
                print("Fetching image for member at index 1")
                
                profileUrl = try await getProfileImageUrl(userId: memberId)
                
                print("Group name: \(chatGroup.groupMembers?.last as Any)")
                print("Profile Url: \(String(describing: profileUrl))")
            }
            else {
                // get image for member at index zeros
                guard let memberId = chatGroup.groupMembers?.first else {
                    print("The user ID doesn't exist. User might have exited the chat")
                    return nil
                }
                
                print("Fetching image for member at index 0 (default admin)")
                
                profileUrl = try await getProfileImageUrl(userId: memberId)
                
                print("Group name: \(chatGroup.groupMembers?.first as Any)")
                print("Profile Url: \(String(describing: profileUrl))")

            }
            
            
        }
        
        return profileUrl
    }
    
    
    func setDisplayImage(chatGroup: [ChatGroup]?) async throws {
        
        if var groups =  chatGroup{
            for i in 0..<groups.count {
                if let element = try? await getDisplayImage(chatGroup: groups[i]) {
                    
                    groups[i].displayImage = element
                }
                
            }
            self.groupChats = groups
        }
        
    }
    
    
    func getGroupName(group: ChatGroup) ->String? {
        if group.groupType == GroupType.multiPerson.rawValue {
            return group.groupName
        }else {
            return user?.userId == group.groupMembers?.first ? group.displayName?.last : group.displayName?.first
        }
    }
    
    
    func timeSinceSent(dateCreated: Date?) -> String? {
        guard let timestamp = dateCreated else {
            print("nil timestamp(dateCreated) was provided")
            return nil
        }

        var timeAgo: String {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            return formatter.localizedString(for: timestamp, relativeTo: Date())
        }
        
        return timeAgo
    }
    
}


struct ChatView: View {
    
    @StateObject private var chatViewModel = ChatVieModel()
    @State private var returnedValue = false
    @State private var selectedTab = "Group Chat"
    
    var body: some View {
        NavigationView {
            VStack{
                
                HStack {
                    Text("")
                        .font(.title)
                        .fontWeight(.bold)
                    //.padding(.bottom, 15)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color("SmithApple"))
                
                //Spacer()
                VStack(alignment: .leading) {
                    /*NavigationLink {
                        ChatThreadView(showChatRoom: <#T##Binding<Bool>#>)
                    } label: {
                        Text("Account")
                            .foregroundColor(.blue)
                    }*/
                    Picker("", selection: $selectedTab) {
                        Text("모임 채팅")
                            .tag("Group Chat")
                        Text("개인 채팅").tag("1to1 Chat")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if selectedTab == "Group Chat"{
                        ScrollView {
                            ForEach(chatViewModel.groupChats, id: \.groupId) { group in
                                if group.groupType == "multi-person" {
                                    NavigationLink {
                                        ChatThreadView(groupId: group.groupId ?? "lG6CpNumnRMTjyny3755", profileImageUrl: group.groupType == GroupType.twoPerson.rawValue ? group.displayImage : group.groupProfileImage, name: chatViewModel.getGroupName(group: group))
                                    } label: {
                                        MessageGilmpseView(department: nil, profilePicUrl: group.groupType == GroupType.twoPerson.rawValue ? group.displayImage : group.groupProfileImage, message: group.recentMessage?.content, bannerName: chatViewModel.user?.userId == group.groupMembers?.first ? group.displayName?.last : group.displayName?.first) {
                                            
                                            chatViewModel.timeSinceSent(dateCreated: group.recentMessage?.dateCreated)
                                            
                                        }
                                    }
                                }

                                /*MessageGilmpseView(department: nil, profilePicUrl: group.groupType == GroupType.twoPerson.rawValue ? group.displayImage : group.groupProfileImage, message: group.recentMessage?.content, bannerName: chatViewModel.user?.userId == group.groupMembers?.first ? group.displayName?.last : group.displayName?.first) {
                                    
                                    chatViewModel.timeSinceSent(dateCreated: group.recentMessage?.dateCreated)
                                    
                                }*/
                                
                                
                            }
                            
                        }
                        .padding(.top, 10)
                        .background(.white)
                    }
                    else{
                        ScrollView {
                            ForEach(chatViewModel.groupChats, id: \.groupId) { group in
                                if group.groupType == "two-person" {
                                    NavigationLink {
                                        ChatThreadView(groupId: group.groupId ?? "lG6CpNumnRMTjyny3755", profileImageUrl: group.groupType == GroupType.twoPerson.rawValue ? group.displayImage : group.groupProfileImage, name: chatViewModel.getGroupName(group: group))
                                    } label: {
                                        MessageGilmpseView(department: nil, profilePicUrl: group.groupType == GroupType.twoPerson.rawValue ? group.displayImage : group.groupProfileImage, message: group.recentMessage?.content, bannerName: chatViewModel.user?.userId == group.groupMembers?.first ? group.displayName?.last : group.displayName?.first) {
                                            
                                            chatViewModel.timeSinceSent(dateCreated: group.recentMessage?.dateCreated)
                                            
                                        }
                                    }
                                }

                                /*MessageGilmpseView(department: nil, profilePicUrl: group.groupType == GroupType.twoPerson.rawValue ? group.displayImage : group.groupProfileImage, message: group.recentMessage?.content, bannerName: chatViewModel.user?.userId == group.groupMembers?.first ? group.displayName?.last : group.displayName?.first) {
                                    
                                    chatViewModel.timeSinceSent(dateCreated: group.recentMessage?.dateCreated)
                                    
                                }*/
                                
                                
                            }
                            
                        }
                        .padding(.top, 10)
                        .background(.white)
                    }
                    
                }
                //.background(Color("SmithApple"))
                
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {  // New in  iOS 16
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CreateMultiPersonGroupView()
                        //AddFriendView()
                    } label: {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.headline)
                            .foregroundColor(.black)
                            //.padding(.horizontal, 3)
                    }
                }
                
            }
            .task {
                print("Loading current user...")
                try? await chatViewModel.loadCurrentUser()
                print("User data loaded!")
                
                print("Fetching group chats...")
                let groups = try? await chatViewModel.getGroupChats()
                print("Group chats fetched!")
                
                print("Attaching profileUrl to two-person chat groups...")
                try? await chatViewModel.setDisplayImage(chatGroup: groups)
                print("profileUrls Attached!")
                
            } // task
        } // VStack
    } // View
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
