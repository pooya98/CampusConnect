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
        ZStack {
            SettingsView(showLoginView: $showLoginView)
        }
        .onAppear {
            //fetch authenticated user from firebase
            //TODO: cutomize error when user is  not authenticated
            let authenticatedUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            
            self.showLoginView = authenticatedUser == nil
        }
        .fullScreenCover(isPresented: $showLoginView) {
            NavigationStack{
                LoginView()
            }
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
