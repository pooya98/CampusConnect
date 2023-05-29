//
//  MessageGilmpseView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/29.
//

import SwiftUI

struct MessageGilmpseView: View {
    
    let name: String
    let department: String
    let profilePicUrl: String?
    let message: String
    let dateSent: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                // Load Profile image
                if let urlString = profilePicUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image.resizable()
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
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Text(name)
                            .fontWeight(.bold)
                            .font(.subheadline)
                        Text(department)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    
                    Text(message)
                        .padding(.horizontal, 10)
                        .font(.footnote)
                }
                
                Text(dateSent).font(.caption)
                
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color("AliceBlue"))
    }
}

struct MessageGilmpseView_Previews: PreviewProvider {
    static var previews: some View {
        MessageGilmpseView(name: "Herbert", department: "컴퓨터학부", profilePicUrl: nil, message: "it is fun. 어제 재미있었어. 잘 가요.어제 재미있었어. 잘 가요.어제 재미있었어. 잘 가요.어제 재미있었어. 잘 가요", dateSent: "Yesterday")
    }
}
