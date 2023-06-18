//
//  GroupRow.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/06/17.
//

import SwiftUI

struct GroupRow: View {
    var group: MyGroup

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(group.imageName)
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(group.name)
                        .font(.headline)
                    Text(group.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(group.memberCount) members")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            if group.isRegular {
                Text("Regular meeting: \(group.meetingDay) at \(group.meetingTime)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("Irregular meeting")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct GroupRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupRow(group: MyGroup(name: "iOS 스터디", description: "RxSwift 공부할 사람~!", memberCount: 10, isRegular: true, meetingDay: "토요일", meetingTime: "오전 10시", imageName: "iOS", location: "IT5호관", category: "자기계발/공부"))
    }
}
