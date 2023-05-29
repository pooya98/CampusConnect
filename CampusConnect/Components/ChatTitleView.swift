//
//  ChatTitleView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

struct ChatTitleView: View {
    var imageUrl = URL(string:"https://cdn.pixabay.com/photo/2016/03/31/20/57/captain-1296107_1280.png")
    
    var name = "Skipper"
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(name)
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
        ChatTitleView()
            .background(Color("SmithApple"))
    }
}
