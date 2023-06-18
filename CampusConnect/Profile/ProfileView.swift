//
//  MyPageView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/24.
//

import SwiftUI
import PhotosUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published var newEmail = ""
    //@Published var profileImage: Image? = nil
    
    /*func loadCurrentUser() async throws {
        let authDataResult = try await AuthenticationManager.shared.getAuthenticatedUser()
    }*/
    
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
    
}

struct ProfileView: View {
    
    
    @StateObject private var profileViewModel =  ProfileViewModel()
    @State private var selectedPhoto: PhotosPickerItem?  = nil
    @State private var url: URL? = nil
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Divider()
                        profile
                        Divider()
                        //myActivity
                        //Divider()
                        //mySchool
                    }
                }
            }
            .toolbar {  // New in  iOS 16
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddFriendView()
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                            .foregroundColor(.black)
                            //.padding(.horizontal, 3)
                    }
                }
            }
            .task {
                try? await profileViewModel.loadCurrentUser()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension ProfileView {
    
    var profile : some View {
        VStack{
            NavigationLink {
                EditProfileView()
            } label: {
                ProfileHeaderSection
            }
            
            HStack{
                Spacer()
                NavigationLink(destination: FriendListView()){
                    VStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Friends")
                            .font(.footnote)
                    }
                }
                
                Spacer()
                NavigationLink(destination: DummyView()){
                    VStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Attendance")
                            .font(.footnote)
                    }
                }
                Spacer()
                NavigationLink(destination: DummyView()){
                    VStack{
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("관심목록")
                            .font(.footnote)
                    }
                }
                Spacer()
            }
        }
        .padding([.leading, .trailing], 10)
        .padding([ .bottom], 15)
        .foregroundColor(.black)
    }
}

extension ProfileView {
    var myActivity : some View {
        VStack(alignment: .leading){
            Text("나의 활동")
                .font(.title3)
                .fontWeight(.bold)
                .padding([.top, .bottom], 5)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("학과 설정하기")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("학과 인증하기")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("키워드 알림")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("친구 초대하기")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("가까운 문 인증하기")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
    }
    
    var mySchool : some View {
        VStack(alignment: .leading){
            Text("우리 학교")
                .font(.title3)
                .fontWeight(.bold)
                .padding([.top, .bottom], 5)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("학교 생활 글/댓글")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("우리학교 탭 1")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("우리학교 탭 2")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("우리학교 탭 3")
            }
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 10)
            
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
    }
}

extension ProfileView {
    
    private var ProfileHeaderSection: some View {
        HStack {
            // MARK: - ISSUE
            
            // TODO: fix Anonymous brief display when page is opened
            // Displays briefly before being dissmissed even though user has a name
            
            // Load profile pic image and display header
            ProfileHeaderView(name: profileViewModel.user?.firstName, department: profileViewModel.user?.department, studentId: profileViewModel.user?.studentId, profilePicUrl: profileViewModel.user?.profileImageUrl)
            
        }
        .padding()
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
