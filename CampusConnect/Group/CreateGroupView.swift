//
//  CreateGroupView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/17.
//

import SwiftUI
import PhotosUI

@MainActor
final class CreateGroupViewModel: ObservableObject {
    @Published var user: DBUser? = nil
    @Published var groupName: String = ""
    @Published var department = Department.none
    @Published var groupNameNotfilled = false
    @Published var meetingType = MeetingType.none
    @Published var meetingDay = MeetingDay.none
    @Published var selectedDate = Date()
    @Published var selectedPhoto: PhotosPickerItem?  = nil
    @Published var groupId : String? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func saveMeetUpProfileImage(item: PhotosPickerItem, groupId: String) {
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                print("Error transfering selected photo from PhotosPickerItem to Data")
                return
            }
            
            /*if let uiImage = UIImage(data: data) {
                profileImage = Image(uiImage: uiImage)
            }*/
            
            let (path, name) = try await StorageManager.shared.saveMeetUpImage(data: data, groupId: groupId)
            print("Saving Profile Image SUCCESS!")
            print(path)
            print(name)
            
            // Download profile image url
            let url = try await StorageManager.shared.getImageUrl(path: path)
            
            // Update value stored in profile path and profile url
            try await MeetUpManager.shared.updateMeetUpProfileImage(groupId: groupId, path: path, url: url.absoluteString)
        }
    }
    
    func createGroup() async throws {
        
        guard let currentUser = user else {
            print("Error! user data not loaded!. User might not have logged in")
            return
        }
        
        guard groupName.isEmpty == false else {
            groupNameNotfilled = true
            print("Group Name required!")
            return
        }
        groupNameNotfilled = false
        
        //let message = Message(id: "007", content: "New group Chat", senderId: "007", senderName: "System", dateCreated: Date(), messageType: MessageType.text.rawValue)
        
        let groupData = MeetUpGroup(groupName: groupName, groupMembers: [currentUser.userId], groupAdminId: [currentUser.userId], groupProfileImageUrl: nil, groupProfileImagePath: nil, department: department.rawValue, meetingType: meetingType.rawValue, meetingDay: meetingDay.rawValue, meetingDate: selectedDate, dateCreated: Date())
        
        self.groupId = try await MeetUpManager.shared.createMeetUpGroup(groupData: groupData)
        
        if let pickedPhoto = selectedPhoto, let groupID = groupId {
            saveMeetUpProfileImage(item: pickedPhoto, groupId: groupID)
        }
        print("Created meet-up group!")
    }
}

struct CreateGroupView: View {
    @ObservedObject private var createGroupViewModel = CreateGroupViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                
                PhotosPicker(selection: $createGroupViewModel.selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    VStack{
                        ProfileAvatarView(personSize: 100, frameSize: 100, imageName: "photo.fill", imageCornerRadius: 0, frameCornerRadius: 30, foregroundColor: .black, backgroundColor: .white, opacity: 0.7)
                        Text("Choose Profile Image")
                            .padding()
                    }
                    
                }
                
                Group {
                    TextField("Group Name", text: $createGroupViewModel.groupName)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                    
                    if(createGroupViewModel.groupNameNotfilled) {
                        Text("Group Name Required")
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    /*TextField("Department", text: $createGroupViewModel.department)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .disableAutocorrection(true)*/
                }
                
                
                Group {
                    HStack{
                        Text("Department ").padding(.horizontal, 15)
                        
                        Spacer()
                        
                        HStack {
                            if(createGroupViewModel.department == Department.none) {
                                Spacer()
                            }
                            
                            Picker("", selection: $createGroupViewModel.department) {
                                ForEach(Department.allCases) { option in
                                    Text(option.rawValue)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 10)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    
                    HStack{
                        Text("Meeting Type ").padding(.horizontal, 15)
                        
                        Spacer()
                        
                        HStack {
                            if(createGroupViewModel.meetingType == MeetingType.none) {
                                Spacer()
                            }
                            
                            Picker("", selection: $createGroupViewModel.meetingType) {
                                ForEach(MeetingType.allCases) { option in
                                    Text(option.rawValue)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 10)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    
                    
                    if(createGroupViewModel.meetingType == MeetingType.oneTime){
                        DatePicker("Meeting Date", selection: $createGroupViewModel.selectedDate, in: Date()...)
                            .padding(.vertical)
                            //.datePickerStyle(GraphicalDatePickerStyle())
                    }
                    else if (createGroupViewModel.meetingType == MeetingType.regular) {
                        
                        HStack{
                            Text("Meeting Day ")
                                .padding(.horizontal, 15)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                if(createGroupViewModel.meetingDay
                                   == MeetingDay.none) {
                                    Spacer()
                                }
                                
                                Picker("", selection: $createGroupViewModel.meetingDay) {
                                    ForEach(MeetingDay.allCases) { option in
                                        Text(option.rawValue)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(.horizontal, 10)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        //.background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        
                        
                        DatePicker("Meeting Time", selection: $createGroupViewModel.selectedDate, displayedComponents: .hourAndMinute).padding(.horizontal)
                    }
                    
                    
                }
               
                
               
                Button {
                    Task {
                        print("Meetup Group Creation ...")
                        //print("Members: \()")
                        try await createGroupViewModel.createGroup()
                        print("Meetup Group Creation complete!")
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
            .navigationTitle("Create Meet-Up Group")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .task {
            print("Loading currentuser data ...")
            try? await createGroupViewModel.loadCurrentUser()
            print("Loading complete!")
        }
        
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
    }
}
