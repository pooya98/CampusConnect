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
    
    private var preview : Bool = true
    
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
                .environmentObject(OwnerView())
        }
    }
    
    let appearance: UITabBarAppearance = UITabBarAppearance()
    
}

enum ownerview {
    case splashview
    case onboardingview
    case signinview
    case signupview
    case mainview
}

class OwnerView: ObservableObject {
    @Published var owner : ownerview
    
    init(){
        self.owner = .splashview
        self.owner = firstloadcheck()
    }
    
    private func firstloadcheck() -> ownerview{
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore == false {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            return ownerview.splashview
        }
        else{
            return ownerview.signinview
        }
    }
}


/*class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}*/
