//
//  CampusConnectApp.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/02.
//

import SwiftUI

@main
struct CampusConnectApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
    
    let appearance: UITabBarAppearance = UITabBarAppearance()
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
