//
//  HomeView2.swift
//  CampusConnect
//
//  Created by 이헌규 on 2023/06/08.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingSearchView = false
    @State private var isShowingNotificationView = false
    @State private var selectedTab = "For You"
    @State var buttonExpanded = false
    @State private var isShowingStory = false
    
    let stories: [Story] = [
        Story(imageName: "profile1", username: "Username1"),
        Story(imageName: "story2", username: "Username2"),
        Story(imageName: "profile3", username: "Username3"),
        Story(imageName: "profile4", username: "Username4"),
        Story(imageName: "profile5", username: "Username5"),
        Story(imageName: "profile6", username: "Username6"),
        Story(imageName: "profile7", username: "Username7"),
    ]
    
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
    
    var body: some View {
        ZStack{
            NavigationView {
                ScrollView {
                    VStack {
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
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                ForEach(stories.reversed()) { story in
                                    StoryView(story: story)
                                        .onTapGesture {
                                            isShowingStory = true
                                        }
                                        .fullScreenCover(isPresented: $isShowingStory) {
                                            StoryDetailView(story: story)
                                        }
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .background(Color.gray)
                        
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
                        
                        Rectangle()
                            .fill(selectedTab == "Discover" ? Color(red: 254/255, green: 248/255, blue: 203/255) : Color(red: 228/255, green: 236/255, blue: 253/255))
                            .frame(height: 100)
                            .padding(.top, -13)
                        
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
                    }
                }
            }
            if buttonExpanded == true {
                Color.gray
                    .opacity(0.7)
                    .animation(.default)
                    .edgesIgnoringSafeArea(.top)
            }
            AnimatedExpandableButton(isExpanded: $buttonExpanded)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
