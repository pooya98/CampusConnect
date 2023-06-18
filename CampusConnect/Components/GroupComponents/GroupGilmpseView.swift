//
//  GroupGilmpseView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/06/17.
//

import SwiftUI

struct GroupGilmpseView: View {
    var body: some View {
        HStack{
            Image("DefaultGroupImage")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .padding([.leading, .trailing], 5)
            VStack(alignment: .leading){
                Text("심컴 IOS 개발 모임")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("IOS 개발자를 희망하는 학생들")
                    .font(.subheadline)
                HStack{
                    Image(systemName: "person")
                    Text("3/5")
                }
                .padding(.top, 5)
            }
            Image(systemName: "heart")
                .resizable()
                .frame(width: 20, height: 20)
                .padding([.leading, .trailing], 10)
        }
    }
}

struct GroupGilmpseView_Previews: PreviewProvider {
    static var previews: some View {
        GroupGilmpseView()
    }
}
