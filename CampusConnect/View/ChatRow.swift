//
//  ChatRow.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/26.
//

import SwiftUI

struct ChatRow: View {
    let chat: Chat
    
    var body: some View {
        HStack{
            chatopponent_image
            chatdescription
            Spacer()
        }
        .frame(height: 60)
    }
}

extension ChatRow {
    var chatopponent_image : some View {
        Image(chat.opponentImageURL)
            .resizable()
            .frame(width: 50, height: 50)
            .padding([.leading, .trailing], 5)
    }
    
    var chatdescription : some View {
        VStack(alignment: .leading){
            HStack {
                Text(chat.opponentName)
                    .fontWeight(.bold)
                Text(chat.opponentRegion)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("1주전")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
            }
            Text(chat.lastchat)
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chat: ChatSamples[0])
    }
}
