//
//  ProfileHeaderView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/28.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    var name: String
    var department: String
    var studentId: String
    var image: Image?
 
    var body: some View {
        ZStack{
            HStack {
                
                if let image {
                    image.resizable()
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)
                }else{
                   ProfileAvatarView(personSize: 80, frameSize: 100)
                }
                
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack{
                        Text(department)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("#" + studentId)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
        }
       
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(name: "Herbert", department: "컴퓨터학부", studentId: "2020110876")
    }
}
