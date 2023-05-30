//
//  CreateAccountViewModel.swift
//  CampusConnect
//
//  Created by Herbert on 2023/05/07.
//

import Foundation


struct AccountRegistrationDetails {
    
    let firstName: String?
    let lastName: String?
    //let dateOfBirth: String?
    //let studentNumber: String?
    
}

@MainActor // concurrency
final class CreateAccountViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var reEnteredPassword = ""
    @Published var firstNameNotfilled = false
    @Published var lastNameNotfilled = false
    @Published var isInvalidEmail = false
    @Published var isInvalidPassword = false
    @Published var passwordsDontMatch = false
    @Published var passwordNotFilled = false
    
    
    // Returns true on successuful creation of account,
    // otherwise it returns false
    func createAccount()  async throws -> Bool {
        //TODO: Ensure Textfield validaiton works properly
        guard firstName.isEmpty == false else {
            firstNameNotfilled = true
            print("First Name required!")
            return false
        }
        firstNameNotfilled = false
        
        
        guard lastName.isEmpty == false else {
            lastNameNotfilled = true
            print("First Name required!")
            return false
        }
        lastNameNotfilled = false
        
        
        guard validateEmail(strToValidate: email) == true else{
            isInvalidEmail = true
            print("Create Account Error: Invalid email address")
            return false
        }
        isInvalidEmail = false
        
        guard password.isEmpty == false else {
            passwordNotFilled = true
            print("Password not provided provided")
            return false
        }
        passwordNotFilled = false
        
        
        guard validatePassword(strToValidate: password) == true else {
            isInvalidPassword = true
            print("Create Account Error: Invalid password format")
            return false
        }
        isInvalidPassword = false
        
        
        guard password == reEnteredPassword else {
            print("Passwords don't match")
            passwordsDontMatch = true
            return false
        }
        passwordsDontMatch = false
        
        // Create user in Firebase Authentication
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        // Write user detail to Firestore
        let regDetails = AccountRegistrationDetails(firstName: firstName, lastName: lastName)
        try await UserManager.shared.createNewUser(authData: authDataResult, registrationDetails: regDetails)
        
        //let userDetails = DBUser(authData: authDataResult, accountDetails: regDetails)
        //try UserManager.shared.createNewUser(user: userDetails)
        
        printLoginStatus()
        
        // Logs out the user who was automatically logged in during account creation
        try AuthenticationManager.shared.signOut()
        
        printLoginStatus()

        return true
    }
    
    
    func validateEmail(strToValidate: String) -> Bool {
        
        let emailDetector = try? NSDataDetector (types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let rangeOfStrToValidate = NSRange ( strToValidate.startIndex..<strToValidate.endIndex, in: strToValidate)
        
        let matches = emailDetector?.matches(
            in: strToValidate,
            options: [],
            range: rangeOfStrToValidate)
        
        
        // Ensure that only a single email address was matched,
        // else the validation fails
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
        
        let passwordFormat = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[ !$%&?~@=#^*()<>+{}:;._-]).{8,}$"

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordFormat)

        return passwordTest.evaluate(with: strToValidate)
        
    }
    
    
    func printLoginStatus() {
        let authenticatedUser =  try? AuthenticationManager.shared.getAuthenticatedUser()
        let loginStatus = authenticatedUser == nil ? "automatically logged out" : "automatically logged in "
        print("User Login Status: \(loginStatus)")
    }
    
}
