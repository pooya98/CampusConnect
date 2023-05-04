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
//    @Published var isValidEmail = false
    
    //method 1
//    func createAccount() async throws {
//        //TODO: validate forms
//
//        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
//    }
    
    //method 2
    func createAccount() {
        //TODO: validate forms
        
//        guard validateEmail(strToValidate: email) == true else{
//            isValidEmail = false
//            return
//        }
//
//        isValidEmail = true
        
        //TODO: display error when email is used by another account
        Task {
            do{
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("New created")
                print(returnedUserData)
            }catch{
                print("Error: \(error)")
            }
        }
        
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
    
}

struct CreateAccountView: View {
    
    @StateObject var createAccountViewmodel = CreateAccountViewModel()
    
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
                .autocapitalization(.none)
                .textCase(.lowercase)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            
//            Text("Invalid email address")
//                .foregroundColor(.red)
//                .font(.footnote)
            
            TextField("password", text: $createAccountViewmodel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
//                TextField("Confirm Password", text: $createAccount.password)
//                    .padding()
//                    .background(Color.gray.opacity(0.4))
//                    .cornerRadius(10)
            
            Button {
                createAccountViewmodel.createAccount()
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
