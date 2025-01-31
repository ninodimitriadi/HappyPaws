//
//  LogInViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseCore
import GoogleSignIn

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
    
    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping (Bool, String?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false, "Client ID not found.")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let result = signInResult else {
                completion(false, "Failed to retrieve sign-in result.")
                return
            }

            let user = result.user
            guard let idToken = user.idToken?.tokenString else {
                completion(false, "ID Token not found.")
                return
            }

            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}
