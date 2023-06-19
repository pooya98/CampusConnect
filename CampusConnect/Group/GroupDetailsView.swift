//
//  GroupDetailsView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/18.
//

import SwiftUI

struct GroupDetailsView: View {
    let groupName: String?
    
    var body: some View {
        VStack {
            MeetupDetailsTitleView(name: groupName)
            //Spacer()
            
            VStack (alignment: .leading){
                Text("Events")
                    .font(.headline)
                
                ScrollView {
                    
                }
                .padding(.top, 10)
                
            }.padding()
        }
    }
}

struct GroupDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailsView(groupName: "Campus MeetUp")
    }
}
