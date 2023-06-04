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
    @Binding var showLoginView: Bool
    
    var body: some View {
        TabView(selection: $selectedTab) {
            home
            mymap
            group
            chat
            myPage
        }.edgesIgnoringSafeArea(.top)
    }
}

extension MainView {
    var home: some View {
        HomeView()
            .tag(Tabs.home)
            .tabItem {
                Image(systemName: "circle")
                Text("홈")
            }
    }
    
    var mymap: some View {
        myMapView()
            .tag(Tabs.create)
            .tabItem {
                Image(systemName: "circle")
                Text("map")
            }
    }
    
    var group: some View {
        GroupView()
            .tag(Tabs.group)
            .tabItem {
                Image(systemName: "circle")
                Text("내모임")
            }
    }
    
    var chat: some View {
        ChatView()
            .tag(Tabs.chat)
            .tabItem {
                Image(systemName: "circle")
                Text("채팅")
            }
    }
    
    var myPage: some View {
        ProfileView(showLoginView: $showLoginView)
            .tag(Tabs.myPage)
            .tabItem {
                Image(systemName: "circle")
                Text("마이페이지")
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showLoginView: .constant(false))
    }
}
