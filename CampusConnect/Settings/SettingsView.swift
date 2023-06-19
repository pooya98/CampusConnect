//
//  SettingsView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/03.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    func logout() throws {
        try AuthenticationManager.shared.signOut()
    }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    @EnvironmentObject var ownerview : OwnerView
    
    var body: some View {
        
        List{
            accountSection
            
            // MARK: - ISSUE
            // The last visited page befoe logout is displyed when user logs in again .
            // The home page should be displayed on every login and not the last visited page
            
            Button {
                Task {
                    do {
                        try viewModel.logout()
                        ownerview.owner = .signinview
                    }catch{
                        // MARK: - TODO
                        
                        // TODO: handle failed logout error
                        // e.g display reason for failed logout on screen
                        print(error)
                    }
                }
            } label: {
                Text("Log Out")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
    }
}

extension SettingsView {
    
    private var accountSection: some View {
        Section {
            NavigationLink{
                AccountView()
            } label: {
                Text("Account")
                    .foregroundColor(.blue)
            }
        } header: {
            Text("Account")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SettingsView()
        }
        
    }
}
