//
//  CampusConnectApp.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/02.
//

import SwiftUI
import Firebase

@main
struct CampusConnectApp: App {
    
    //Method1: Connecting firebase without app delegate.
    init(){
        FirebaseApp.configure()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    //Method2: Connecting firebase with app delegate.
    //You might need app delegate for certain firebase packages. Only use when necessary
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
    let appearance: UITabBarAppearance = UITabBarAppearance()
    
//    init() {
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
}


/*class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}*/
