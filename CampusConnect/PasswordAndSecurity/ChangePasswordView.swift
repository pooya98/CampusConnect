//
//  ChangePasswordView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/07.
//

import SwiftUI

@MainActor
final class ChangePasswordViewModel: ObservableObject {
    @Published var newPassword = ""
    @Published var verifyPassword = ""
    @Published var passwordNotFilled = false
    @Published var isInvalidPassword = false
    @Published var passwordsNotMatch = false
    
    // get values from user
    func updatePassword () async throws -> Bool {
        guard newPassword.isEmpty == false, verifyPassword.isEmpty == false else {
            passwordNotFilled = true
            print(" New password not provided.")
            return false
        }
        passwordNotFilled = false
        
        guard validatePassword(strToValidate: newPassword) == true else {
            isInvalidPassword = true
            print("Change Password Error: Invalid password format")
            return false
        }
        isInvalidPassword = false
        
        guard newPassword == verifyPassword else {
            print("Passwords don't match")
            passwordsNotMatch = true
            return false
        }
        passwordsNotMatch = false
        
        try await AuthenticationManager.shared.updatePassword(password: newPassword)
        
        return true
    }
    
    func validatePassword(strToValidate: String) -> Bool {
        
        // .{8,} or (?=.{8,}) - At least 8 characters
        
        // (?=.*[A-Z]) - At least one capital letter

        // (?=.*[a-z]) - At least one lowercase letter

        // (?=.*\d)" or (?=.*[0-9]) - At least one digit

        // At least one special character
        //(?=.*[ !$%&?~@=#^*()<>+{}:;._-])
        
        let passwordFormat = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[ !$%&?~@=#^*()<>+{}:;._-]).{8,}$"

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordFormat)

        return passwordTest.evaluate(with: strToValidate)
        
    }
    
}

struct ChangePasswordView: View {
    
    @StateObject private var changePassViewModel = ChangePasswordViewModel()
    @Binding var showChangePassSheet: Bool
    @Binding var showChangedPassAlert: Bool
    @State var showChangePassError = ""
    @State var showChangePassErrorAlert = false
    @State var buttonDisabled = false
    @State var isDoneDisabled = true
    
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            HStack {
                Button {
                    // dismiss ChangePasswordView
                    showChangePassSheet = false
                    
                } label: {
                    Text("Cancel")
                        .font(.title3)
                }
                .padding()
                .disabled(buttonDisabled)
                
                Spacer()
                
                Button {
                    // dismiss ChangePasswordView
                    showChangePassSheet = false
                    
                } label: {
                    Text("Done")
                        .font(.title3)
                }
                .padding()
                .disabled(isDoneDisabled)
            }
            
            
            VStack {
                
                SecureField("New password", text: $changePassViewModel.newPassword)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                SecureField("re-enter password", text: $changePassViewModel.verifyPassword)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                if (changePassViewModel.passwordNotFilled) {
                    Text("Both password values must be filled")
                        .foregroundColor(.red)
                    .font(.footnote)
                    
                }
                
                if(changePassViewModel.isInvalidPassword){
                    Text("Your password must be at least 8 characters, include and a number, lowercase letter, uppercase letter and a special character")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                if(changePassViewModel.passwordsNotMatch) {
                    Text("Passwords don't match")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Button {
                    Task {
                        
                        do {
                            let changePassSuccess = try await changePassViewModel.updatePassword()
                            
                            print("Password Changed: \(changePassSuccess)")
                            
                            if changePassSuccess {
                                // mutes a button
                                buttonDisabled = true
                                isDoneDisabled = false
                                
                                // display Change Password success alert
                                showChangedPassAlert = true
                            }
                            
                        } catch {
                            print("Change Password Failed: \(error)")
                            
                            showChangePassError = error.localizedDescription
                            
                            showChangePassErrorAlert = true
                        }
                        
                    }
                    
                } label: {
                    
                    if buttonDisabled {
                        Text("Change Password")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.9))
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.9))
                            .cornerRadius(10)
                    }else{
                        Text("Change Password")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                }
                .padding(.top, 20)
                .disabled(buttonDisabled)
                
                // MARK: - Password Changed Alert
                .alert("Password Changed", isPresented: $showChangedPassAlert){
                    
                } message: {
                    Text("Use the new password the next time you log in.")
                        .fontWeight(.medium)
                }
                
                // MARK: - Change Passowrd Error
                .alert("Change Password Failed:", isPresented: $showChangePassErrorAlert){
                    
                } message: {
                    Text(showChangePassError)
                        .fontWeight(.medium)
                }
                
            }
            .padding()
            .frame(maxHeight: .infinity)
            
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(showChangePassSheet: .constant(false), showChangedPassAlert: .constant(false))
    }
}
