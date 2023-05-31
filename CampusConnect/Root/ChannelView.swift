//
//  ChannelView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/28.
//

import SwiftUI

struct ChannelView: View {
   
    var body: some View {
        NavigationView{
            VStack {
                /*NavigationLink {
                    ChatView(showChatRoom: <#T##Binding<Bool>#>)
                } label: {
                    Text("Account")
                        .foregroundColor(.blue)
                }*/
                
            }.navigationTitle("Chats")
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}
