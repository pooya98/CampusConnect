//
//  MeetupDetailsTitleView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/18.
//

import SwiftUI

struct MeetupDetailsTitleView: View {
    //var profilePicUrl: String?
    let name: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // MARK: - TODO
                // TODO: Add profile picture
                Text(name ?? "MeetUp")
                    .font(.title2)
                    .bold()
            }
            
            Spacer()
    
            Image(systemName: "line.3.horizontal")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("SmithApple"))
    }
}

struct MeetupDetailsTitleView_Previews: PreviewProvider {
    static var previews: some View {
        MeetupDetailsTitleView(name: "Campus MeetUp")
    }
}
