//
//  ChatTitleView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

struct ChatTitleView: View {
    var profileimageUrl: String?
    var name: String?
    
    var body: some View {
        HStack(spacing: 20) {
            /*AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }*/
            
            ProfileAvatarView(profilePicUrl: profileimageUrl, personSize: 37, frameSize: 50)
            
            VStack(alignment: .leading) {
                Text(name ?? "Anonymous")
                    .font(.title)
                    .bold()
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
    
            Image(systemName: "phone.fill")
                .foregroundColor(.gray)
                .padding(10).background(.white)
                .cornerRadius(50)
        }
        .padding()
        .frame(maxWidth: .infinity)
        
    }
}

struct ChatTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatTitleView(profileimageUrl: nil, name: "Skipper")
            .background(Color("SmithApple"))
    }
}
