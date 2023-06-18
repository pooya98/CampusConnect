//
//  GroupDetailView.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/06/17.
//

import SwiftUI

struct GroupDetailView: View {
    var group: MyGroup
    
    var body: some View {
        HStack(alignment: .top){
            Image(group.imageName)
                .resizable()
                .frame(width: 150, height: 150)
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                Text(group.name)
                    .font(.title)
                Text(group.description)
                    .font(.body)
                    .foregroundColor(.gray)
                Text("멤버 \(group.memberCount) 명")
                    .font(.body)
                    .foregroundColor(.gray)
                if group.isRegular {
                    Text("정기모임: \(group.meetingDay) \(group.meetingTime)")
                        .font(.body)
                        .foregroundColor(.gray)
                } else {
                    Text("Irregular meeting")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: MyGroup(name: "iOS 스터디", description: "RxSwift 공부할 사람~!", memberCount: 10, isRegular: true, meetingDay: "토요일", meetingTime: "오전 10시", imageName: "iOS", location: "IT5호관", category: "자기계발/공부"))
    }
}
