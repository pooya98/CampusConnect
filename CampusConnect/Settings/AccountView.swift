//
//  AccountView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/05.
//

import SwiftUI

struct AccountView: View {
    
    //@StateObject private var accountViewModel = AccountViewModel()
    @State var showDeleteAlert = false
    @State var showReauthSheet = false
    @Binding var showLoginView: Bool
    
    
    var body: some View {
        List {
            NavigationLink{
                ProfileView()
            } label: {
                Text("Profile")
                    .foregroundColor(.blue)
            }
            
            NavigationLink{
                PasswordAndSecurityView()
            } label: {
                Text("Password and Security")
                    .foregroundColor(.blue)
            }
            
            deleteSection
            
        }.navigationTitle("Account")
    }
}

extension AccountView {
    
   
    
    private var deleteSection: some View {
        Section {
            Button(role: .destructive) {
                
                showDeleteAlert = true
                
            } label: {
                Text("Delete Account")
            }
            // MARK: - Delete Account Alert
            .alert("Delete Account", isPresented: $showDeleteAlert) {
                // Add buttons like OK, CANCEL here
                Button("Cancel",role: .cancel) {}
                
                Button("Confirm",role: .destructive) {
                    showReauthSheet = true
                }
                
            } message: {
                Text("This action will permanenlty erase your data. Do you want to procced?")
                    .fontWeight(.medium)
            }
            .sheet(isPresented: $showReauthSheet){
                EmailReauthView(showLoginView: $showLoginView, showReauthSheet: $showReauthSheet)
            }
            
        } header: {
            Text("Danger zone")
                .foregroundColor(.red)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountView(showLoginView: .constant(false))
        }
        
    }
}
