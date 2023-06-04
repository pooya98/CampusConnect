//
//  ChatView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/24.
//

import SwiftUI

struct ChatView2: View {
    let chatlist : [Chat]
    
    var body: some View {
        NavigationView {
            VStack{
                titlebar
                Divider()
                Spacer()
                chatList
                
            }
        }
    }
}

extension ChatView2 {
    var titlebar : some View {
        HStack {
            Text("채팅")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                print("Configuration Button")
            }) {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.black)
            }
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
    }
    
    var chatList : some View {
        List(chatlist){ chat in
            ZStack {
                ChatRow(chat: chat)
                NavigationLink(destination: ChatDetailView()) {
                    EmptyView()
                }.opacity(0)
                
            }
        }
        .listStyle(.inset)
    }
}

struct ChatView2_Previews: PreviewProvider {
    static var previews: some View {
        ChatView2(chatlist: ChatSamples)
    }
}
