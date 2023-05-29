//
//  ProfileAvatarView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/28.
//

import SwiftUI

struct ProfileAvatarView: View {
    
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
}

struct ProfileAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAvatarView(personSize: 80, frameSize: 100)
    }
}
