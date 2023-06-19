//
//  ProfileAvatarView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/28.
//

import SwiftUI

/*struct ProfileAvatarView: View {
    
    var personSize: CGFloat
    var frameSize: CGFloat
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: personSize, height: personSize)
                .opacity(0.7)
                .cornerRadius(40)
        }
        .frame(width: frameSize, height: frameSize)
        .background(Color("LavenderGray"))
        .cornerRadius(50)
       
    }
}*/

struct ProfileAvatarView: View {
    
    var profilePicUrl: String?
    var personSize: CGFloat
    var frameSize: CGFloat
    var imageName: String?
    var imageCornerRadius: CGFloat?
    var frameCornerRadius: CGFloat?
    var foregroundColor: Color?
    var backgroundColor: Color?
    var opacity: CGFloat?
    
    var body: some View {
        
        // Display profile picture
        if let url = profilePicUrl {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .foregroundColor(foregroundColor ?? .white)
                    .frame(width: frameSize, height: frameSize)
                    .cornerRadius(imageCornerRadius ?? 50)
            } placeholder: {
                ProgressView()
                    .frame(width: frameSize, height: frameSize)
            }
            
        } else {
            HStack {
                
                if let image = imageName {
                    Image(systemName: image)
                        .resizable()
                        .foregroundColor(foregroundColor ?? .white)
                        .frame(width: personSize, height: personSize)
                        .opacity(opacity ?? 0.7)
                        .cornerRadius(imageCornerRadius ?? 50)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundColor(foregroundColor ?? .white)
                        .frame(width: personSize, height: personSize)
                        .opacity(opacity ?? 0.7)
                        .cornerRadius(imageCornerRadius ?? 50)
                }
                
                
            }
            .frame(width: frameSize, height: frameSize)
            .background(backgroundColor ?? Color("LavenderGray"))
            .cornerRadius(frameCornerRadius ?? 50)
            
        }
    }
    
}

struct ProfileAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAvatarView(personSize: 80, frameSize: 100)
    }
}
