//
//  GroupChatDetailsView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/04.
//

import SwiftUI
import PhotosUI

@MainActor
final class GroupChatDetailsViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var group: ChatGroup? = nil
    @Published var groupName: String = ""
    @Published var groupId : String? = nil
    @Published var selectedPhoto: PhotosPickerItem?  = nil
    
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func saveGroupProfileImage(item: PhotosPickerItem, groupId: String) {
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                print("Error transfering selected photo from PhotosPickerItem to Data")
                return
            }
            
            /*if let uiImage = UIImage(data: data) {
                profileImage = Image(uiImage: uiImage)
            }*/
            
            let (path, name) = try await StorageManager.shared.saveGroupImage(data: data, groupId: groupId)
            print("Saving Profile Image SUCCESS!")
            print(path)
            print(name)
            
            // Download profile image url
            let url = try await StorageManager.shared.getImageUrl(path: path)
            
            // Update value stored in profile path and profile url
            try await ChatManager.shared.updateGroupProfileImagePath(groupId: groupId, path: path, url: url.absoluteString)
        }
    }
    
    
    func deleteProfileImage() {
        guard let group, let path = group.groupProfileImagePath else { return }
        
        Task {
            // MARK: - TODO
            // user do catch to capture the error
            try await StorageManager.shared.deleteImage(path: path)
            
            if let groupID = groupId{
                try await ChatManager.shared.updateGroupProfileImagePath(groupId: groupID, path: nil, url: nil)
            }
            
        }
    }
    
    func createGroup(groupMembers: [String]) async throws {
        
        guard let currentUser = user else {
            print("Error! user data not loaded!. User might not have logged in")
            return
        }
        
        //let message = Message(id: "007", content: "New group Chat", senderId: "007", senderName: "System", dateCreated: Date(), messageType: MessageType.text.rawValue)
        
        let groupData = ChatGroup(groupName: groupName, groupMembers: groupMembers, groupAdminId: [currentUser.userId], recentMessage: nil, groupProfileImage: nil, groupProfileImagePath: nil, groupType: GroupType.multiPerson.rawValue, dateCreated: Date())
        
        self.groupId = try await ChatManager.shared.createChatGroup(groupData: groupData)
        
        if let pickedPhoto = selectedPhoto, let groupID = groupId {
            saveGroupProfileImage(item: pickedPhoto, groupId: groupID)
        }
        print("Created multi-person chat room!")
    }
    
}

struct GroupChatDetailsView: View {
    @StateObject private var groupChatDetailsViewModel = GroupChatDetailsViewModel()
    var groupChatMembers: [String]
    
    var body: some View {
        NavigationView {
            VStack{
                
                PhotosPicker(selection: $groupChatDetailsViewModel.selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    VStack{
                        ProfileAvatarView(personSize: 80, frameSize: 100, imageName: "person.2.fill")
                        Text("Choose Profile Image")
                            .padding()
                    }
                    
                }
                
                TextField("Group Name..", text: $groupChatDetailsViewModel.groupName)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .disableAutocorrection(true)
                
                
                Button {
                    Task {
                        print("Chat Group Creation ...")
                        print("Members: \(groupChatMembers)")
                        try await groupChatDetailsViewModel.createGroup(groupMembers: groupChatMembers)
                        print("Chat Group Creation complete!")
                    }
                } label: {
                    Text("Create Group")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 50)

            }
            .navigationTitle("Create Group")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .task {
            print("Loading currentuser data ...")
            try? await groupChatDetailsViewModel.loadCurrentUser()
            print("Loading complete!")
        }
       
    }
}

struct GroupChatDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatDetailsView(groupChatMembers: ["007", "Bond"])
    }
}
