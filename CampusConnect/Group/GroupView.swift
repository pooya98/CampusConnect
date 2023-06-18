import SwiftUI

struct GroupView: View {
    var groups = [
        MyGroup(name: "iOS 스터디", description: "RxSwift 공부할 사람~!", memberCount: 10, isRegular: true, meetingDay: "토요일", meetingTime: "오전 10시", imageName: "iOS", location: "IT5호관", category: "자기계발/공부"),
        MyGroup(name: "축구 한 판 하싈?", description: "새벽 축구 하고 국밥 한 그릇~", memberCount: 15, isRegular: true, meetingDay: "", meetingTime: "", imageName: "Soccer", location: "서문 풋살장", category: "스포츠/운동"),
        MyGroup(name: "MUNK: 강아지 산책", description: "저녁 먹고 선선할 때 강아지 산책시켜요!", memberCount: 15, isRegular: true, meetingDay: "", meetingTime: "", imageName: "Dogs", location: "센트럴파크", category: "인간관계(친목)"),
        MyGroup(name: "Yori보고 Zori보고", description: "요리 배우고 나눠 먹어요!", memberCount: 30, isRegular: true, meetingDay: "", meetingTime: "", imageName: "Yori", location: "백호관", category: "음식"),
        MyGroup(name: "탁구왕 김탁구", description: "탁구왕 김탁구로왕", memberCount: 12, isRegular: true, meetingDay: "Thursday", meetingTime: "09:00", imageName: "Pingpong", location: "복현오거리", category: "스포츠/운동"),
        MyGroup(name: "맛집 탐방 수사대", description: "숨은 맛집 탐방대", memberCount: 22, isRegular: true, meetingDay: "Friday", meetingTime: "10:30", imageName: "Foods", location: "북문", category: "음식"),
        MyGroup(name: "Friday Party", description: "This is Group 8", memberCount: 18, isRegular: false, meetingDay: "", meetingTime: "", imageName: "iOS", location: "동성로", category: "술"),
        MyGroup(name: "모여서 각자 코딩", description: "This is Group 9", memberCount: 27, isRegular: false, meetingDay: "Saturday", meetingTime: "11:00", imageName: "iOS", location: "IT5호관", category: "자기계발/공부"),
        MyGroup(name: "두류공원 피!크!닉!", description: "This is Group 10", memberCount: 32, isRegular: false, meetingDay: "", meetingTime: "", imageName: "GroupImage/Books", location: "두류공원", category: "인간관계(친목)")
    ]

    @State private var favorite = Array(repeating: false, count: 10)
    @State private var selectedTab = "Regular Meetings"

    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("정기 모임").tag("Regular Meetings")
                    Text("번개 모임").tag("Flash Meetings")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            
                ZStack {
                    if selectedTab == "Regular Meetings" {
                        regularMeetingsView()
                    }
                    
                    if selectedTab == "Flash Meetings" {
                        flashMeetingsView()
                    }

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(red: 246/255, green: 201/255, blue: 246/255))
                                    .clipShape(Circle())
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
                }
            }
        }
    }
    
    func regularMeetingsView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 5) {
                ForEach(groups.indices.filter { groups[$0].isRegular }, id: \.self) { index in
                    groupCellView(index: index)
                }
            }
            .padding(.horizontal)
        }
    }
    
    func flashMeetingsView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 5) {
                ForEach(groups.indices.filter { !groups[$0].isRegular }, id: \.self) { index in
                    groupCellView(index: index)
                }
            }
            .padding(.horizontal)
        }
    }
    
//  func groupCellView(index: Int) -> some View {
//      NavigationLink(destination: GroupDetailView(group: groups[index])) {
//          HStack(alignment: .top) {
//              VStack(alignment: .center) {
//                groups[index].image
//                      .resizable()
//                      .frame(width: 20, height: 20)
//                      .clipShape(RoundedRectangle(cornerRadius: 20))
//                  Button(action: {
//                      favorite[index].toggle()
//                  }) {
//                      Image(systemName: favorite[index] ? "heart.fill" : "heart")
//                          .resizable()
//                          .frame(width: 10, height: 20)
//                          .foregroundColor(favorite[index] ? .red : .white)
//                  }
//              }
//              .frame(width: 40)
//
//              VStack(alignment: .leading, spacing: 5) {
//                  Text(groups[index].name)
//                      .font(.headline)
//                      .foregroundColor(.black)
//                      .fixedSize(horizontal: false, vertical: true)
//                      .layoutPriority(1)
//                  Text(groups[index].description)
//                      .font(.footnote)
//                      .foregroundColor(.gray)
//                      .fixedSize(horizontal: false, vertical: true)
//                  Text("Location | 멤버 \(groups[index].memberCount) | Category")
//                      .font(.caption2)
//                      .foregroundColor(.gray)
//                      .fixedSize(horizontal: false, vertical: true)
//              }
//              .layoutPriority(1)
//          }
//          .padding(.vertical, 10)
//      }
//  }
  
  func groupCellView(index: Int) -> some View {
      NavigationLink(destination: GroupDetailView(group: groups[index])) {
          HStack {
              HStack(alignment: .top) {
                  VStack(alignment: .center) {
                      Image(groups[index].imageName)
                          .resizable()
                          .frame(width: 60, height: 60)
                          .clipShape(RoundedRectangle(cornerRadius: 20))
                          .padding(.leading, 30)
                      Button(action: {
                          favorite[index].toggle()
                      }) {
                          Image(systemName: favorite[index] ? "heart.fill" : "heart")
                              .resizable()
                              .frame(width: 10, height: 20)
                              .foregroundColor(favorite[index] ? .red : .white)
                      }
                  }
                  .frame(width: 40)
                  .padding(.trailing, 40)
                  
                  VStack(alignment: .leading, spacing: 5) {
                      Text(groups[index].name)
                          .font(.headline)
                          .foregroundColor(.black)
                          .fixedSize(horizontal: false, vertical: true)
                          .layoutPriority(1)
                      Text(groups[index].description)
                          .font(.footnote)
                          .foregroundColor(.gray)
                          .fixedSize(horizontal: false, vertical: true)
                      Text("\(groups[index].location) | 멤버 \(groups[index].memberCount) | \(groups[index].category)")
                          .font(.caption2)
                          .foregroundColor(.gray)
                          .fixedSize(horizontal: false, vertical: true)
                  }
                  .layoutPriority(1)
              }
            Spacer()
          }
          .padding(.vertical, 0)
      }
  }


}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
