//
//  ProfileHeaderView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/28.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    var name: String?
    var department: String?
    var studentId: String?
    //var image: Image?
    var profilePicUrl: String?
 
    var body: some View {
        VStack{
            HStack{
                ProfileAvatarView(profilePicUrl: profilePicUrl, personSize: 47, frameSize: 70 )
                VStack(alignment: .leading){
                    Text(name ?? "Anonymous")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(department ?? "")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(name: "Herbert", department: "컴퓨터학부", studentId: "202312345")
    }
}
