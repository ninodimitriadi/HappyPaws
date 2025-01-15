//
//  SignUpViewController.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import UIKit
import SwiftUI

class SignUpViewController: UIViewController {
    
    private let viewModel = SignUpViewModel()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "dog")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var viewForFields: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.opacity = 0.8
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private var logInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create an account"
        label.font = UIFont(name: "Raleway-Bold", size: 27)
        label.textColor = .customBlue
        
        return label
    }()
    
    private lazy var mailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Email Address"
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
    
    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Username"
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
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Password"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.customBlue.cgColor
        textField.layer.shadowColor = UIColor.customBlue.cgColor
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4

        let eyeImageView = UIImageView(image: UIImage(systemName: "eye"))
        eyeImageView.tintColor = .gray
        let eyeTapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        eyeImageView.isUserInteractionEnabled = true
        eyeImageView.addGestureRecognizer(eyeTapGesture)

        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        eyeImageView.center = rightView.center
        rightView.addSubview(eyeImageView)
        textField.rightView = rightView
        textField.rightViewMode = .always

        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.configureButton(title: "Sign Up", fontSize: 17, backgroundColor: .customBlue)
        button.layer.cornerRadius = 5
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.pressSignUpButton(button: button)
        }), for: .touchUpInside)
        
        
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "OR Log In with"
        label.font = UIFont(name: "Raleway-Regular", size: 15)
        label.textColor = .customBlue
        
        return label
    }()
    
    private lazy var loginWithGoogle: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 23
        button.setImage(UIImage(named: "google"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.googleSignInTapped()
        }), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        
        button.addAction(UIAction(handler: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpConstraints()
        viewModel.delegate = self
    }
    
    private func setUpUI() {
        view.addSubview(backgroundImage)
        view.addSubview(viewForFields)
        view.addSubview(backButton)
        viewForFields.addSubview(logInLabel)
        viewForFields.addSubview(mailTextField)
        viewForFields.addSubview(userNameTextField)
        viewForFields.addSubview(passwordTextField)
        viewForFields.addSubview(signUpButton)
        viewForFields.addSubview(orLabel)
        viewForFields.addSubview(loginWithGoogle)
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
            viewForFields.heightAnchor.constraint(equalToConstant: 445),
            viewForFields.widthAnchor.constraint(equalToConstant: 310)
        ])
        
        NSLayoutConstraint.activate([
            logInLabel.centerXAnchor.constraint(equalTo: viewForFields.centerXAnchor),
            logInLabel.topAnchor.constraint(equalTo: viewForFields.topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            mailTextField.topAnchor.constraint(equalTo: logInLabel.bottomAnchor, constant: 30),
            mailTextField.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            mailTextField.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            mailTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 20),
            userNameTextField.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            userNameTextField.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            userNameTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20),
            passwordTextField.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            passwordTextField.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signUpButton.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            signUpButton.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            signUpButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            orLabel.centerXAnchor.constraint(equalTo: viewForFields.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginWithGoogle.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20),
            loginWithGoogle.heightAnchor.constraint(equalToConstant: 46),
            loginWithGoogle.widthAnchor.constraint(equalToConstant: 46),
            loginWithGoogle.centerXAnchor.constraint(equalTo: viewForFields.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeIcon = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        if let eyeImageView = passwordTextField.rightView?.subviews.first as? UIImageView {
            eyeImageView.image = UIImage(systemName: eyeIcon)
        }
    }
    
    private func pressSignUpButton(button: UIButton) {
        
        guard let email = mailTextField.text,
              let username = userNameTextField.text,
              let password = passwordTextField.text, !email.isEmpty, !username.isEmpty, !password.isEmpty else {
            AlertManager.showRegistrationErrorAlert(on: self, with: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please fill out all fields."]))
            return
        }
        
        viewModel.registerUser(username: username, email: email, password: password)
    }
    
    private func googleSignInTapped() {
        viewModel.signInWithGoogle(presenting: self) { [weak self] success, error in
            if success {
                self?.navigationController?.pushViewController(TabBarViewController(), animated: true)
            } else if let error = error {
                AlertManager.showBasicAlert(on: LogInViewController(), title: "Error", message: error)
            }
        }
    }
}
    
    
extension SignUpViewController: SignUpViewModelDelegate {
    func registrationCompleted(success: Bool, error: Error?) {
        if let error = error {
            AlertManager.showRegistrationErrorAlert(on: self, with: error)
            return
        }
        
        if success {
            let successAlert = UIAlertController(title: "Registration Successful", message: "Your account has been created successfully!", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(successAlert, animated: true, completion: nil)
        } else {
            AlertManager.showRegistrationErrorAlert(on: self)
        }
    }
}


struct SignUpViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> SignUpViewController {
    return SignUpViewController()
  }
  
  func updateUIViewController(_ uiViewController: SignUpViewController, context: Context) {}
}

#Preview {
    SignUpViewControllerWrapper()
}
