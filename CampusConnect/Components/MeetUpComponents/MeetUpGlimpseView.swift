//
//  MeetUpGlimpseView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/06/18.
//

import SwiftUI

struct MeetUpGlimpseView: View {
    let groupName: String?
    let profilePicUrl: String?
    let memberCount: String
    let meetingType: String?
    let meetingDay: String?
    let meetingDate: () -> String?
   
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack{
                
                if let url = profilePicUrl {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(50)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                    
                } else {
                    Text(groupName?.prefix(2).uppercased() ?? "GR")
                        .padding()
                        .foregroundColor(.black)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 60, height: 60)
                        .background(Color("SmithApple"))
                        .cornerRadius(50)
                }
                
                VStack(alignment: .leading) {
                    HStack{
                        Text(groupName ?? "")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                        Spacer()
                        
                        HStack {
                            if(memberCount == "1") {
                                Text("\(memberCount) member")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }else {
                                Text("\(memberCount) members")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                        }
                    }
                    
                    HStack {
                        
                        Group {
                            if(meetingType != MeetingType.none.rawValue) {
                                Text("\(meetingType ?? ""): ")
                                    .font(.footnote)
                            }
                            
                            if(meetingDay != MeetingType.none.rawValue) {
                                Text(meetingDay ?? "")
                                    .font(.footnote)
                            }
                            
                            Text(meetingDate() ?? "")
                                .font(.footnote)
                        }
                        .foregroundColor(.gray)
                        
                    }
                    .padding(.top, 1)
                    .padding(.horizontal, 10)
                }
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
       
    }
}

struct MeetUpGlimpseView_Previews: PreviewProvider {
    static var previews: some View {
        MeetUpGlimpseView(groupName: "Campus Connect", profilePicUrl: nil, memberCount: "0", meetingType: MeetingType.regular.rawValue, meetingDay: MeetingDay.Monday.rawValue, meetingDate: {"10:00 PM"})
    }
}
