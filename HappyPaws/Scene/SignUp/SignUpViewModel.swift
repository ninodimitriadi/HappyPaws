//
//  SignUpViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

//import Foundation
//
//class SignUpViewModel {
//    var username: String = ""
//    var email: String = ""
//    var password: String = ""
//    
//    var isUsernameValid: Bool {
//        return Validator.isValidUsername(for: username)
//    }
//    
//    var isEmailValid: Bool {
//        return Validator.isValidEmail(for: email)
//    }
//    
//    var isPasswordValid: Bool {
//        return Validator.isPasswordValid(for: password)
//    }
//    
//    var isFormValid: Bool {
//        return isUsernameValid && isEmailValid && isPasswordValid
//    }
//    
//    func signUp(completion: @escaping (Bool, Error?) -> Void) {
//        let registerRequest = RegisterRequest(username: username, email: email, password: password)
//        
//        AuthService.shared.registerUser(with: registerRequest) { wasRegistered, error in
//            completion(wasRegistered, error)
//        }
//    }
//    
//    func showValidationErrors() -> [String]? {
//        var errors: [String] = []
//        
//        if !isUsernameValid {
//            errors.append("Invalid username")
//        }
//        
//        if !isEmailValid {
//            errors.append("Invalid email")
//        }
//        
//        if !isPasswordValid {
//            errors.append("Invalid password")
//        }
//        
//        return errors.isEmpty ? nil : errors
//    }
//}

import Foundation
import FirebaseAuth


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
                print("nort error")
            } else {
                self.delegate?.registrationCompleted(success: false, error: nil)
            }
        }
    }
}
