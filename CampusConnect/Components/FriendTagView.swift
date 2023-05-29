//
//  FriendTagView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/29.
//

import SwiftUI

struct FriendTagView: View {
    var name: String
    var department: String
    var profilePicUrl: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {

                // Display profile picture
                if let url = profilePicUrl {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .cornerRadius(50)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }

                }else {
                    ProfileAvatarView(personSize: 40, frameSize: 60)
                }
                
                
                VStack(alignment: .leading) {
                    Text(name)
                        .fontWeight(.bold)
                        .font(.subheadline)
                    
                    Text(department)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
            }
            //.background(Color("LumGreen"))
            
        }
        //.padding()
        .frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
        //.background(Color("AliceBlue"))
    }
}

struct FriendTagView_Previews: PreviewProvider {
    static var previews: some View {
        FriendTagView(name: "Herbert", department: "컴퓨터학부")
    }
}
