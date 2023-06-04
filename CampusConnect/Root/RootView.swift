//
//  RootView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/03.
//

import SwiftUI

struct RootView: View {
    
    @State private var showLoginView: Bool = false
    
    var body: some View {
        VStack {
            NavigationStack {
                if showLoginView == false { // prevents page from displaying before successful login
                    
                    // Default View after successful login
                    MainView(showLoginView: $showLoginView)
                    //SettingsView(showLoginView: $showLoginView)
                }
                
            }
            
            
            /*if showLoginView == false { // prevents page from displaying before successful login
                
                // Default View after successful login
                MainView(showLoginView: $showLoginView)
                //SettingsView(showLoginView: $showLoginView)
            }*/
            
            //SettingsView(showLoginView: $showLoginView)
            
            
        }
        .onAppear {
            // MARK: - TODO
            
            
            //TODO: cutomize error when user is  not authenticated
            //fetch authenticated user from firebase
            let authenticatedUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            
            let loginStatus = authenticatedUser == nil ? "logged out" : "logged in"
            print("User Login Status: \(loginStatus)")
            
            self.showLoginView = authenticatedUser == nil
        }
        .fullScreenCover(isPresented: $showLoginView) {
            NavigationStack{
                LoginView(showLoginView: $showLoginView)
            }
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
