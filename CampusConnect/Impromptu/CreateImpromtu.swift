//
//  CreateImpromtu.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/06/19.
//

import SwiftUI
import _PhotosUI_SwiftUI

@MainActor
final class CreateImpromptuViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    @Published var impromptuId: String? = ""
    @Published var location = ""
    @Published var i_time = ""
    @Published var title = ""
    @Published var selectedPhoto: PhotosPickerItem?  = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func createImpromptu() async throws {
        guard let currentUser = user else {
            print("Error! user data not loaded!. User might not have logged in")
            return
        }
        
        let ImpromptuData = Impromptu(ImpromptuName: title, ImpromptuAdminId: currentUser.userId, ImpromptuLocation: location, ImpromptuTime: i_time, dateCreated: Date())
        
        self.impromptuId = try await ImpromptuManager.shared.createImpromptu(impromptuData: ImpromptuData)
        
        if let pickedPhoto = selectedPhoto, let impromptuId = impromptuId {
            saveImpromptuImage(item: pickedPhoto, impromptuId: impromptuId)
        }
    }
    
    func saveImpromptuImage(item: PhotosPickerItem, impromptuId: String) {
        
        guard let user else { return }
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                print("Error transfering selected photo from PhotosPickerItem to Data")
                return
            }
            
            let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: user.userId)
            print("Saving Profile Image SUCCESS!")
            print(path)
            print(name)
            
            // Download profile image url
            let url = try await StorageManager.shared.getImageUrl(path: path)
            
            // Update value stored in profile path and profile url
            try await ImpromptuManager.shared.updateImpromptuImagePath(impromptuId: impromptuId, path: path, url: url.absoluteString)
        }
    }
    
}

struct CreateImpromtu: View {
    
    @StateObject var createImpromptuViewModel = CreateImpromptuViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State var stage : Int = 1
    @Binding var isShownFullScreenCover: Bool
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack{
            HStack{
                Text("번개 생성")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    self.isShownFullScreenCover.toggle()
                } label: {
                    Text("cancel")
                }
            }
            .padding([.top], 30)
            .padding([.leading], 30)
            
            Spacer()
            if stage == 1 {
                HStack{
                    Text("이미지를 선택해주세요")
                        .font(.title2)
                        .fontWeight(.bold
                        )
                    Spacer()
                }
                .padding([.leading], 30)
                
            }
            else{
                HStack{
                    Text("장소와 시각을 작성해주세요")
                        .font(.title2)
                        .fontWeight(.bold
                        )
                    Spacer()
                }
                .padding([.leading], 30)
            }
            
            VStack{
                PhotosPicker(
                    selection: $createImpromptuViewModel.selectedPhoto,
                    matching: .images,
                    photoLibrary: .shared()) {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 400)
                        }
                        else{
                            ZStack{
                                Rectangle()
                                    .frame(width: 350, height: 500)
                                    .opacity(0.3)
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .foregroundColor(Color.gray)
                        }
                    }
                    .onChange(of: createImpromptuViewModel.selectedPhoto) { newItem in
                        Task {
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
                
                if stage == 2 {
                    VStack{
                        TextField("모임 설명", text: $createImpromptuViewModel.title)
                            .padding()
                            .border(Color.gray, width: 0.5)
                        
                        TextField("모임 시각", text: $createImpromptuViewModel.i_time)
                            .padding()
                            .border(Color.gray, width: 0.5)
                        
                        TextField("모임 장소", text: $createImpromptuViewModel.location)
                            .padding()
                            .border(Color.gray, width: 0.5)
                    }
                    .padding([.leading, .trailing], 20)
                }
            }
            
            Spacer()
            
            HStack{
                if stage == 1{
                    Button {
                        stage = 2
                    } label: {
                        Text("다음")
                            .frame(width: 350, height: 50)
                            .background(Color(red: 247/255, green: 202/255, blue: 246/255))
                            .cornerRadius(10)
                            .foregroundColor(Color.white)
                    }
                }
                else{
                    Button {
                        stage = 1
                    } label: {
                        Text("이전")
                            .frame(width: 170, height: 50)
                            .background(Color(red: 247/255, green: 202/255, blue: 246/255))
                            .cornerRadius(10)
                            .foregroundColor(Color.white)
                    }
                    Button {
                        Task {
                            stage = 3
                            try await createImpromptuViewModel.createImpromptu()
                            self.isShownFullScreenCover.toggle()
                        }
                    } label: {
                        Text("게시하기")
                            .frame(width: 170, height: 50)
                            .background(Color(red: 247/255, green: 202/255, blue: 246/255))
                            .cornerRadius(10)
                            .foregroundColor(Color.white)
                        
                    }
                }
            }
            .padding([.bottom], 30)
        }
        .animation(.default)
        .task {
            print("Loading currentuser data ...")
            try? await createImpromptuViewModel.loadCurrentUser()
            print("Loading complete!")
        }
        .onDisappear(){
            isExpanded = false
        }
    }
    
    
}

struct CreateImpromtu_Previews: PreviewProvider {
    static var previews: some View {
        CreateImpromtu(isShownFullScreenCover: .constant(false), isExpanded: .constant(false))
    }
}
