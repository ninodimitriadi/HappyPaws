//
//  LogInViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import Foundation
import FirebaseAuth

class LogInViewModel {
    var email: String = ""
    var password: String = ""
    
    var emailError: String?
    var passwordError: String?
    
    func validateFields() -> Bool {
        var isValid = true
        
        emailError = nil
        passwordError = nil
        
        if email.isEmpty {
            emailError = "Email is required."
            isValid = false
        } else if !Validator.isValidEmail(for: email) {
            emailError = "Invalid email format."
            isValid = false
        }
        
        if password.isEmpty {
            passwordError = "Password is required."
            isValid = false
        } else if !Validator.isPasswordValid(for: password) {
            passwordError = "Password is incorrect"
            isValid = false
        }
        
        return isValid
    }
    
    func logIn(completion: @escaping (Bool, String?) -> Void) {
        let loginRequest = LoginRequest(email: email, password: password)
        
        AuthService.shared.signIn(with: loginRequest) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
}
