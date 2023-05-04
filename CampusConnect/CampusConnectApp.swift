//
//  CampusConnectApp.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/02.
//

import SwiftUI
import Firebase

@main
struct CampusConnectApp: App {
    
    //Method1: Connecting firebase without app delegate.
    init(){
        FirebaseApp.configure()
    }
    
    //Method2: Connecting firebase with app delegate.
    //You might need app delegate for certain firebase packages. Only use when necessary
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}


//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
