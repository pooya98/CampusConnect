//
//  MessageGilmpseView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/29.
//

import SwiftUI

struct MessageGilmpseView: View {
    
    let department: String?
    let profilePicUrl: String?
    let message: String?
    let bannerName: String?
    let dateSent:  () -> String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                
                // Load Profile image
                ProfileAvatarView(profilePicUrl: profilePicUrl, personSize: 40, frameSize: 60)
                

                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Text(bannerName ?? "Anonymous")
                            .fontWeight(.bold)
                            .font(.subheadline)
                        Text(department ?? "")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    
                    Text(message ?? "")
                        .padding(.horizontal, 10)
                        .font(.footnote)
                }
                
                Spacer()
                
                Text(dateSent() ?? "-").font(.caption)
                
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color("SmithApple").opacity(0.6))
        //.background(Color("AliceBlue"))
    }
}

struct MessageGilmpseView_Previews: PreviewProvider {
    static var previews: some View {
        MessageGilmpseView(department: "컴퓨터학부", profilePicUrl: nil, message: "it is fun. 어제 재미있었어. 잘 가요.어제 재미있었어. 잘 가요.어제 재미있었어. 잘 가요.어제 재미있었어. 잘 가요",bannerName: "Sparrow", dateSent: {"Yesterday"})
    }
}
