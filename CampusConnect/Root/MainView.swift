//
//  MainView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/26.
//

import SwiftUI

struct MainView: View {
    @Binding var showLoginView: Bool
    
    var body: some View {
        TabView {
            Group {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                ChatView()
                    .tabItem {
                        Label("Chat", systemImage: "message")
                    }
                
                ProfileView(showLoginView: $showLoginView)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }.navigationTitle("Profile")
            }
            //.toolbar(.visible, for: .tabBar)
            .toolbarBackground(Color.blue.opacity(0.2), for: .tabBar)
        }
        .tint(.black)
        //.navigationTitle("Home")

    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainView(showLoginView: .constant(false))
        }
    }
}
