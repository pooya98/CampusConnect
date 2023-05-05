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
    @Binding var showLoginView: Bool
    
    var body: some View {
        
        List{
            accountSection
            
            Button {
                Task {
                    do {
                        try viewModel.logout()
                        showLoginView = true
                    }catch{
                        //TODO: handle failed logout error
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
            SettingsView(showLoginView: .constant(false))
        }
        
    }
}
