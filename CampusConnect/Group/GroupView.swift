//
//  GroupView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/24.
//

import SwiftUI

struct GroupView: View {
    var body: some View {
        NavigationView{
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Divider()
                        //profile
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
            }
            .task {
                //try? await profileViewModel.loadCurrentUser()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
