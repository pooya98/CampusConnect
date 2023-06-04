//
//  ResetPasswordView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/10.
//

import SwiftUI

@MainActor // concurrency
final class ResetPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var emailPasswordNotFilled = false
    
    // returns true on successful login
    func resetPassword() async throws -> Bool {
        guard email.isEmpty == false else {
            emailPasswordNotFilled = true
            print("No email found.")
            return false
        }
        
        emailPasswordNotFilled = false
        
        try await AuthenticationManager.shared.resetPassword(email: email)
        
        return true
    }
}

struct ResetPasswordView: View {
    
    @StateObject var resetPassViewModel = ResetPasswordViewModel()
    @State var showResetLinkSentAlert = false
    @State var resetPassErrorMesssage = ""
   // @State var showResetFailedAlert = false
    
    var body: some View {
        
        
        VStack{
            Text("Enter your account email")
            
            TextField("Email", text: $resetPassViewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if (resetPassViewModel.emailPasswordNotFilled) {
                Text("Must provide an email")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button {
                // Add send reset logic
                Task {
                    do {
                        let resetSuccess = try await resetPassViewModel.resetPassword()
                        
                        if (resetSuccess) {
                            // inform user
                            print("Reset Password link sent")
                            
                            showResetLinkSentAlert = true
                        }
                        
                    } catch {
                        //showResetFailedAlert = true
                        print("Reset Password Failed: \(error)")
                        resetPassErrorMesssage = error.localizedDescription
                    }
                }
            } label: {
                Text("Send")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            // MARK: - Link Sent Alert
            .alert("Reset Link Sent", isPresented: $showResetLinkSentAlert) {
                // Add buttons like OK, CANCEL here
            } message: {
                Text("A link has been sent to the provided email. Check your email and follow the provided steps")
                    .fontWeight(.medium)
            }
            
            // MARK: - Reset Failed Alert
            /*.alert("Reset Password Failed", isPresented: $showResetFailedAlert) {
                // Add buttons like OK, CANCEL here
            } message: {
                Text(resetPassErrorMesssage)
                    .fontWeight(.medium)
            }*/
            
            Text("No response? Click on the send button to resend ")
                .padding(.top, 30)
                .font(.footnote)
        }
        .navigationTitle("Reset Password")
        .padding()
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ResetPasswordView()
        }
        
    }
}

