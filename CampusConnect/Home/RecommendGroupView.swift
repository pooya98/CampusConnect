//
//  RecommendGroupView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/06/20.
//

import SwiftUI

struct RecommendGroupView: View {
    var group: RecommendGroup

    var body: some View {
        VStack(alignment: .leading) {
            Image(group.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 120)
                .clipped()
                .cornerRadius(10)
                .padding(.top, -10)
                .padding(.leading, -10)
            
            Text(group.title)
                .font(.headline)
                .padding(.top, 5)
                .padding(.leading, -10)
            
            Text(group.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)  // 설명이 2줄을 넘지 않도록
                .padding(.leading, -10)
                .padding(.bottom, -10)

        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

//struct RecommendGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecommendGroupView()
//    }
//}
