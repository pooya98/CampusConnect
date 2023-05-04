//
//  CreateAccountView.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/03.
//

import SwiftUI

@MainActor // concurrency
final class CreateAccountViewModel: ObservableObject {
//    @Published var firstname = ""
//    @Published var lastname = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isInvalidEmail = false
    @Published var isInvalidPassword = false
    
    //method 1
//    func createAccount() {
//        //TODO: validate forms
//
//        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
//    }
    
    //method 2
    func createAccount()  async throws{
        //TODO: validate forms
        guard validateEmail(strToValidate: email) == true else{
            isInvalidEmail = true
            print("Create Account Error: Invalid email address")
            return
        }
        
        isInvalidEmail = false
        
        guard validatePassword(strToValidate: password) == true else {
            isInvalidPassword = true
            print("Create Account Error: Invalid password pattern")
            return
        }

        isInvalidPassword = false
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    
    func validateEmail(strToValidate: String) -> Bool {
        
        let emailDetector = try? NSDataDetector (types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let rangeOfStrToValidate = NSRange ( strToValidate.startIndex..<strToValidate.endIndex, in: strToValidate)
        
        let matches = emailDetector?.matches(
            in: strToValidate,
            options: [],
            range: rangeOfStrToValidate)
        
        
        // Ensure that only a single email address was matched
        //Else the validation fails
        guard matches?.count == 1 else {
            return false
        }
        let singleMatch = matches?.first
        
        // Ensure that range covers the whole strToValidate:
        guard singleMatch?.range == rangeOfStrToValidate else {
            return false
        }
        
        // Verify that the found link points to an email
        //address
        guard singleMatch?.url?.scheme == "mailto" else {
            return false
        }
        
        return true
    }
    
    func validatePassword(strToValidate: String) -> Bool {
        
        // .{8,} or (?=.{8,}) - At least 8 characters
        
        // (?=.*[A-Z]) - At least one capital letter

        // (?=.*[a-z]) - At least one lowercase letter

        // (?=.*\d)" or (?=.*[0-9]) - At least one digit

        // At least one special character
        //(?=.*[ !$%&?~@=#^*()<>+{}:;._-])
        
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[ !$%&?~@=#^*()<>+{}:;._-]).{8,}$"

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordPattern)

        return passwordTest.evaluate(with: strToValidate)
        
    }
    
}

struct CreateAccountView: View {
    
    @StateObject var createAccountViewmodel = CreateAccountViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var accountCreationAlert = false
    
    var body: some View {
        VStack{
            
//            TextField("First Name", text: $createAccount.firstname)
//                .padding()
//                .background(Color.gray.opacity(0.4))
//                .cornerRadius(10)
//
//            TextField("Last Name", text: $createAccount.lastname)
//                .padding()
//                .background(Color.gray.opacity(0.4))
//                .cornerRadius(10)

            TextField("Email", text: $createAccountViewmodel.email)
//                .autocapitalization(.none)
//                .textCase(.lowercase)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if(createAccountViewmodel.isInvalidEmail){
                Text("Invalid email address")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            TextField("Password", text: $createAccountViewmodel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            if(createAccountViewmodel.isInvalidPassword){
                Text("Password must be at least 8 characters and contain number, lowercase, uppercase, special character")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
//                TextField("Confirm Password", text: $createAccountViewmodel.password)
//                    .padding()
//                    .background(Color.gray.opacity(0.4))
//                    .cornerRadius(10)
            
            Button {
                Task {
                    do{
                        try await createAccountViewmodel.createAccount()
                        // dismiss current view
                        dismiss()
                        accountCreationAlert = true
                        

                    }catch{
                        //TODO: display error when email is used by another account
                        print("Error: \(error)")
                    }
                }
            } label: {
                Text("Create Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 40)
            .alert("Account Created", isPresented: $accountCreationAlert){
                
                // Add buttons like OK, CANCEL here
                
            } message: {
                Text("You can now login.")
            }
            
        }
        .padding()
        .navigationTitle("Create Account")
    }
    
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
