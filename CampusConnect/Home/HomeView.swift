//
//  HomeView2.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/06/08.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var impromptu_list : [Impromptu] = []
    
    func getImpromptus() async throws {
        self.impromptu_list = try await ImpromptuManager.shared.getImpromptus()
    }

}

struct HomeView: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @State private var isShowingSearchView = false
    @State private var isShowingNotificationView = false
    @State private var selectedTab = "For You"
    @State var buttonExpanded = false
    @State var isShowingCreateView = "none"
    @State private var isShowingStory = false
    
    var categories: [Category] = [
        Category(imageName: "Communication", categoryName: "인간관계(친목)"),
        Category(imageName: "Study", categoryName: "자기계발/공부"),
        Category(imageName: "Sports", categoryName: "스포츠/운동"),
        Category(imageName: "Alcohol", categoryName: "술"),
        Category(imageName: "Art", categoryName: "예술"),
        Category(imageName: "Foods", categoryName: "음식"),
        Category(imageName: "Life", categoryName: "라이프"),
        Category(imageName: "CategoryAll", categoryName: "전체보기")
    ]
    
    let recommendGroups: [RecommendGroup] = [
        RecommendGroup(imageName: "Barbeque", title: "옥상 낭만 🍖바베큐파티!", description: "옥탑방 바베큐파티~"),
        RecommendGroup(imageName: "SpaceCrew", title: "협동 갓겜 <스페이스 크루>", description: "[협동 + 우주] 보드게임"),
        RecommendGroup(imageName: "Talking", title: "남 얘기 들어보기", description: "친구도 한때는 '남'이었다")
    ]
    
    let hotGroups: [RecommendGroup] = [
        RecommendGroup(imageName: "Tea", title: "다도🫖배우기", description: "같이 보이차 마셔요!"),
        RecommendGroup(imageName: "Beer", title: "수제맥주 만들기", description: "퀄리티 있는 수제 맥주 직접 만들자"),
        RecommendGroup(imageName: "Flower", title: "꽃 좋아하세요?", description: "플로리스트 체험하기")
    ]

    let closingSoonGroups: [RecommendGroup] = [
        RecommendGroup(imageName: "Wine", title: "저녁 와인 한 잔", description: "같이 와인🍷 한 잔 어때?"),
        RecommendGroup(imageName: "Movie", title: "인생 영화 찾기", description: "당신의 영화 취향🎬"),
        RecommendGroup(imageName: "Whisky", title: "위스키 마십시다", description: "요즘 🔥한 위스키")
    ]

    let newGroups: [RecommendGroup] = [
        RecommendGroup(imageName: "Dogs", title: "MUNK: 강아지 산책", description: "같이 🐶강아지 산책시켜요"),
        RecommendGroup(imageName: "Yori", title: "Yori보고 Zori보고", description: "직접 만들어 먹는 재미"),
        RecommendGroup(imageName: "Soccer", title: "축.구.클.럽", description: "공 한 번 찹시다")
    ]
    
    var body: some View {
        ZStack{
            NavigationView {
                ScrollView {
                    VStack {
                        topBar
                        impromptulist
                        
                        Divider().background(Color.gray)
                        
                        subTabBar
                        middleboxbackground
                        
                        
                        if selectedTab == "For You" {
                            Text("Herbert님을 위해 인간지능으로 한땀 한땀 골라봤어요!")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.top, -90)
                                .padding(.leading, -80)
                        }
                        
                        if selectedTab == "Discover" {
                            Text("편안하게 둘러보세요!")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(.top, -90)
                                .padding(.leading, -170)
                        }
                        
                        if selectedTab == "For You" {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    Image("Basketball")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 344, height: 200)
                                        .cornerRadius(10)
                                    Image("Chicken")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 344, height: 200)
                                        .cornerRadius(10)
                                    Image("ForeignerFriends")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 344, height: 200)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 60)
                        }
                        
                        if selectedTab == "For You" {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                                ForEach(categories) { category in
                                    VStack {
                                        Image(category.imageName)
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .background(Circle().foregroundColor(Color(red: 0xF6/255, green: 0xC9/255, blue: 0xF6/255)))
                                        Text(category.categoryName)
                                            .font(.caption)
                                            .foregroundColor(Color(red: 0x6A/255, green: 0x6B/255, blue: 0x6D/255))
                                    }
                                }
                            }
                            .padding(.top, 70)
                            .padding()
                        }
                        
                        
                        VStack{
                            if selectedTab == "For You" {
                                // 취향 맞춤 소모임
                                VStack(alignment: .leading) {
                                    Text("✔️ 취향 맞춤 소모임")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .padding(.leading, 20)
                                    
                                    
                                    Text("관심사 기반으로 추천해드려요")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .padding(.bottom, -20)
                                        .padding(.leading, 20)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: -10) {
                                            ForEach(recommendGroups) { group in
                                                RecommendGroupView(group: group)
                                            }
                                        }
                                        .padding()
                                    }
                                }
                                Divider()
                                    .padding(.top, -20)
                            }
                            // 받고 있는 소모임
                            VStack(alignment: .leading) {
                                Text("❤️ 받고 있는 소모임")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.leading, 20)
                                    .padding(.top, -10)
                                
                                
                                Text("최근 찜을 받은 소모임이에요")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, -20)
                                    .padding(.leading, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: -10) {
                                        ForEach(hotGroups) { group in
                                            RecommendGroupView(group: group)
                                        }
                                    }
                                    .padding()
                                }
                                Divider()
                                    .padding(.top, -20)
                            }
                            
                            // 마감 임박 소모임
                            VStack(alignment: .leading) {
                                Text("⏰ 마감 임박 소모임")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.leading, 20)
                                    .padding(.top, -10)
                                
                                Text("지금이 아니면 못 갈지 몰라요")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, -20)
                                    .padding(.leading, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: -10) {
                                        ForEach(closingSoonGroups) { group in
                                            RecommendGroupView(group: group)
                                        }
                                    }
                                    .padding()
                                }
                                Divider()
                                    .padding(.top, -20)
                            }
                            
                            // 따끈따끈 신규 소모임
                            VStack(alignment: .leading) {
                                Text("🐣 따끈따끈 신규 소모임")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.leading, 20)
                                    .padding(.top, -10)
                                
                                
                                Text("처음은 늘 특별해")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, -20)
                                    .padding(.leading, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: -10) {
                                        ForEach(newGroups) { group in
                                            RecommendGroupView(group: group)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        
                    }
                }
            }
            if buttonExpanded == true {
                Color.gray
                    .opacity(0.7)
                    .animation(.default)
                    .edgesIgnoringSafeArea(.top)
            }
            AnimatedExpandableButton(isExpanded: $buttonExpanded, selected: $isShowingCreateView)
        }
        .task {
            try? await homeViewModel.getImpromptus()
            print(homeViewModel.impromptu_list)
        }
    }
}

extension HomeView {
    var topBar : some View {
        HStack {
            Spacer()
            Button(action: {
                isShowingSearchView = true
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .fullScreenCover(isPresented: $isShowingSearchView) {
                SearchView()
            }
            
            Button(action: {
                isShowingNotificationView = true
            }) {
                Image(systemName: "bell")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .fullScreenCover(isPresented: $isShowingNotificationView) {
                NotificationView()
            }
        }
        .padding(.horizontal)
    }
    
    var impromptulist : some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(homeViewModel.impromptu_list, id: \.ImpromptuImageUrl) { impromptu in
                    StoryView(story: Story(imageUrl: impromptu.ImpromptuImageUrl ?? "", storyname: impromptu.ImpromptuName ?? ""))
                        .onTapGesture {
                            isShowingStory = true
                        }
                        .fullScreenCover(isPresented: $isShowingStory) {
                            StoryDetailView(i_url: impromptu.ImpromptuImageUrl, i_name: impromptu.ImpromptuName, i_location: impromptu.ImpromptuLocation, i_time: impromptu.ImpromptuTime)
                        }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    var subTabBar : some View {
        HStack {
            Text("For You")
                .font(.headline)
                .fontWeight(selectedTab == "For You" ? .bold : .light)
                .underline(selectedTab == "For You", color: .black)
                .foregroundColor(selectedTab == "For You" ? .black : .gray)
                .onTapGesture {
                    selectedTab = "For You"
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Discover")
                .font(.headline)
                .fontWeight(selectedTab == "Discover" ? .bold : .light)
                .underline(selectedTab == "Discover", color: selectedTab == "Discover" ? .black : .black)
                .foregroundColor(selectedTab == "Discover" ? .black : .gray)
                .onTapGesture {
                    selectedTab = "Discover"
                }
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 20)
        .padding(.trailing, 220)
    }
    
    var middleboxbackground : some View {
        Rectangle()
            .fill(selectedTab == "Discover" ? Color(red: 254/255, green: 248/255, blue: 203/255) : Color(red: 228/255, green: 236/255, blue: 253/255))
            .frame(height: 100)
            .padding(.top, -13)
    }
}

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



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
