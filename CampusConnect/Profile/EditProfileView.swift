//
//  EditProfileView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/28.
//

import SwiftUI
import PhotosUI

@MainActor
final class EditProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var newEmail = ""
    @Published var selectedPhoto: PhotosPickerItem?  = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    // MARK: - TODO
    // TODO: implement UI to get new email address that should be set after editing currrent email
    // NOTE: remember to reauthenticate user before updating email
    // get value from user input
    func updateEmail (email: String) async throws {
        try await AuthenticationManager.shared.updateEmail(email: email)
    }

    
    func saveProfileImage(item: PhotosPickerItem) {
        
        guard let user else { return }
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                print("Error transfering selected photo from PhotosPickerItem to Data")
                return
            }
            
            /*if let uiImage = UIImage(data: data) {
                profileImage = Image(uiImage: uiImage)
            }*/
            
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
            print("Saving Profile Image SUCCESS!")
            print(path)
            print(name)
            
            // Download profile image url
            let url = try await StorageManager.shared.getImageUrl(path: path)
            
            // Update value stored in profile path and profile url
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path, url: url.absoluteString)
        }
    }
    
    func deleteProfileImage() {
        guard let user, let path = user.profileImagePath else { return }
        
        Task {
            // MARK: - TODO
            // user do catch to capture the error
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil, url: nil)
        }
    }
    
}


struct EditProfileView: View {
    @StateObject var editProfileViewModel = EditProfileViewModel()
    
    
    var body: some View {
        VStack(spacing: 30){
            
            // MARK: - TODO
            
            // TODO: Display new profile pic immediately after selection
            // Currently the profile pic image is not updated immediately after selection.
            // The user has to exit the view an reopen it to see an updated
            // version displayed
            PhotosPicker(selection: $editProfileViewModel.selectedPhoto, matching: .images, photoLibrary: .shared()) {
                
                // Load profile image
                // Displays default avatar image if url is nil
                ProfileAvatarView(profilePicUrl: editProfileViewModel.user?.profileImageUrl, personSize: 80, frameSize: 100)
            }
            
            VStack(spacing: 20) {
                Text("Name")
                Text("Department")
                
                if editProfileViewModel.user?.profileImagePath != nil {
                    Button {
                        editProfileViewModel.deleteProfileImage()
                    } label: {
                        Text("Remove Profile Picture")
                    }
                }
            }.padding()
           
            
        }
        .task{
            // MARK: - TODO
            // TODO: use a do catch for the error
            try? await editProfileViewModel.loadCurrentUser()
        }
        .onChange(of: editProfileViewModel.selectedPhoto, perform: { newValue in
            if let newValue {
                editProfileViewModel.saveProfileImage(item: newValue)
            }
            
            // Delete old profile image when a new one id selected
            Task{
                editProfileViewModel.deleteProfileImage()
            }
        })
        .navigationTitle("Edit Profile")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditProfileView()
        }
       
    }
}
