//
//  MainTabView.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/24.
//

import SwiftUI

struct MainTabView: View {
    private enum Tabs {
        case home, group, create, chat, myPage
    }
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            home
            group
            create
            chat
            myPage
        }.edgesIgnoringSafeArea(.top)
    }
    
    var home: some View {
        Text("홈")
            .tag(Tabs.home)
            .tabItem {
                Image(systemName: "circle")
                Text("홈")
            }
    }
    
    var group: some View {
        Text("내모임")
            .tag(Tabs.group)
            .tabItem {
                Image(systemName: "circle")
                Text("내모임")
            }
    }
    
    var create: some View {
        Text("생성")
            .tag(Tabs.create)
            .tabItem {
                Image(systemName: "circle")
                Text("생성")
            }
    }
    
    var chat: some View {
        Text("채팅")
            .tag(Tabs.chat)
            .tabItem {
                Image(systemName: "circle")
                Text("채팅")
            }
    }
    
    var myPage: some View {
        Text("마이페이지")
            .tag(Tabs.myPage)
            .tabItem {
                Image(systemName: "circle")
                Text("마이페이지")
            }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
