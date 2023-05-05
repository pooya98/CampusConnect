//
//  AccountView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/05.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        List {
            NavigationLink{
                ProfileView()
            } label: {
                Text("Profile")
                    .foregroundColor(.blue)
            }
        }.navigationTitle("Account")
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountView()
        }
        
    }
}
