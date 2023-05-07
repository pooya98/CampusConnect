//
//  PasswordAndSecurityView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/06.
//

import SwiftUI


struct PasswordAndSecurityView: View {
    
    @StateObject private var passAndSecViewModel = PasswordAndSecurityViewModel()
    @State private var showLoginSheet = false
    @State private var showChangePassSheet = false
    @State var showChangedPassAlert = false
    
    var body: some View {
        
        List {
            Button{
                showLoginSheet = true
                
            } label: {
                Text("Change Password")
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginSheetView(showLoginSheet: $showLoginSheet, showChangePassSheet: $showChangePassSheet)
            }
            
            // Displayed after reauthenticaation in the LoginSheetView
            .sheet(isPresented: $showChangePassSheet) {
                ChangePasswordView(showChangePassSheet: $showChangePassSheet, showChangedPassAlert: $showChangedPassAlert)
            }
            
            NavigationLink{
                
            } label: {
                Text("Two-Factor Authentication")
                    .foregroundColor(.blue)
            }
            
        }.navigationTitle("Password and Security")
    
    }
}


struct PasswordAndSecurityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PasswordAndSecurityView()
        }

    }
}
