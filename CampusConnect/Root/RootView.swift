//
//  RootView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/03.
//

import SwiftUI


struct RootView: View {
    
    @EnvironmentObject var ownerview : OwnerView
    
    var body: some View {
        VStack {
            switch(ownerview.owner){
            case .splashview:
                SplashView()
            case .onboardingview:
                OnboardingView()
            case .signupview:
                CreateAccountView()
            case .signinview:
                LoginView()
            case .mainview:
                MainView()
            }
        }
        .onAppear {
            // MARK: - TODO
            
            
            //TODO: cutomize error when user is  not authenticated
            //fetch authenticated user from firebase
            let authenticatedUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            
            let loginStatus = authenticatedUser == nil ? "logged out" : "logged in"
            print("User Login Status: \(loginStatus)")
            
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(OwnerView())
    }
}
