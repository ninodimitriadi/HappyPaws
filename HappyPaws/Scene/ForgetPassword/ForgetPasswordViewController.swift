//
//  ForgetPasswordViewController.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import UIKit
import SwiftUI

class ForgetPasswordViewController: UIViewController {
    
    private let viewModel = ForgotPasswordViewModel()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "pets")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var viewForFields: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.opacity = 0.9
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var resetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Raleway-Bold", size: 30)
        label.textColor = .customBlue
        return label
    }()
    
    private lazy var mailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.customBlue.cgColor
        textField.layer.shadowColor = UIColor.customBlue.cgColor
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4
        return textField
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.configureButton(title: "", fontSize: 17, backgroundColor: .customBlue)
        button.layer.cornerRadius = 5
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.resetButtomTapped(button: button)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private var progressView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpConstraints()
        viewModel.delegate = self
        reloadUIForNewLanguage()
    }
    
    private func setUpUI() {
        view.addSubview(backgroundImage)
        view.addSubview(viewForFields)
        view.addSubview(progressView)
        viewForFields.addSubview(resetLabel)
        viewForFields.addSubview(mailTextField)
        viewForFields.addSubview(resetButton)
        view.addSubview(backButton)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            viewForFields.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewForFields.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewForFields.heightAnchor.constraint(equalToConstant: 250),
            viewForFields.widthAnchor.constraint(equalToConstant: 310)
        ])
        
        NSLayoutConstraint.activate([
            resetLabel.centerXAnchor.constraint(equalTo: viewForFields.centerXAnchor),
            resetLabel.topAnchor.constraint(equalTo: viewForFields.topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            mailTextField.topAnchor.constraint(equalTo: resetLabel.bottomAnchor, constant: 30),
            mailTextField.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            mailTextField.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            mailTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 30),
            resetButton.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            resetButton.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            resetButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func reloadUIForNewLanguage() {
        resetLabel.text = LanguageManager.shared.localizedString(forKey: "reset_password")
        mailTextField.placeholder = LanguageManager.shared.localizedString(forKey: "email_address")
        resetButton.setTitle(LanguageManager.shared.localizedString(forKey: "reset_password"), for: .normal)
    }
    
    private func resetButtomTapped(button: UIButton) {
        progressView.startAnimating()
        let email = mailTextField.text ?? ""
        viewModel.resetPassword(email: email)
    }
}

extension ForgetPasswordViewController: ForgotPasswordViewModelDelegate {
    func sendPasswordResetEmail(success: Bool, error: String?) {
        progressView.stopAnimating()
        if success {
            AlertManager.showPasswordResetSent(on: self)
        } else if let error = error {
            AlertManager.showErrorSendingPasswordReset(on: self, with: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error]))
        }
    }
}


struct ForgetPasswordViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> ForgetPasswordViewController {
    return ForgetPasswordViewController()
  }
  
  func updateUIViewController(_ uiViewController: ForgetPasswordViewController, context: Context) {}
}

#Preview {
    ForgetPasswordViewControllerWrapper()
}
