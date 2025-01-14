//
//  ForgetPasswordViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

protocol ForgotPasswordViewModelDelegate: AnyObject {
    func sendPasswordResetEmail(success: Bool, error: String?)
}

final class ForgotPasswordViewModel {
    
    weak var delegate: ForgotPasswordViewModelDelegate?
    
    func resetPassword(email: String) {
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            if let error = error {
                self?.delegate?.sendPasswordResetEmail(success: false, error: error.localizedDescription)
            } else {
                self?.delegate?.sendPasswordResetEmail(success: true, error: nil)
            }
        }
    }
}
