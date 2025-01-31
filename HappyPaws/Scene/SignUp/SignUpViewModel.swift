//
//  SignUpViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseCore
import GoogleSignIn


protocol SignUpViewModelDelegate: AnyObject {
    func registrationCompleted(success: Bool, error: Error?)
}


class SignUpViewModel {


    weak var delegate: SignUpViewController?


    func registerUser(username: String, email: String, password: String) {
        let registerUserRequest = RegisterRequest(username: username, email: email, password: password)
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.registrationCompleted(success: false, error: error)
                return
            }
            
            if wasRegistered {
                self.delegate?.registrationCompleted(success: true, error: nil)
            } else {
                self.delegate?.registrationCompleted(success: false, error: nil)
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
