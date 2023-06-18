//
//  MainTabView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/24.
//

import SwiftUI

struct MainView: View {
    private enum Tabs {
        case home, group, create, chat, myPage
    }
    
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            home
            //mymap
            group
            chat
            myPage
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(.black)
    }
}

extension MainView {
    var home: some View {
        HomeView()
            .tag(Tabs.home)
            .tabItem {
                Image(selectedTab == .home ? "HomeIconFilled" : "HomeIconOutlined")
                .renderingMode(.template)
            }
    }
    
    /*
    var mymap: some View {
        myMapView()
            .tag(Tabs.create)
            .tabItem {
                Image(selectedTab == .mymap ? "MapIconFilled" : "MapIconOutlined")
                .renderingMode(.template)
            }
    }
     */
    
    var group: some View {
        GroupView()
            .tag(Tabs.group)
            .tabItem {
                Image(selectedTab == .group ? "MyGroupIconFilled" : "MyGroupIconOutlined")
                .renderingMode(.template)
            }
    }
    
    var chat: some View {
        ChatView()
            .tag(Tabs.chat)
            .tabItem {
                Image(selectedTab == .chat ? "ChatIconFilled" : "ChatIconOutlined")
                .renderingMode(.template)
            }
    }
    
    var myPage: some View {
        ProfileView()
            .tag(Tabs.myPage)
            .tabItem {
                Image(selectedTab == .myPage ? "MyPageIconFilled" : "MyPageIconOutlined")
                .renderingMode(.template)
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
