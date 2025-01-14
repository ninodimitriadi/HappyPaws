//
//  SignUpViewController.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import UIKit
import SwiftUI

class SignUpViewController: UIViewController {
    
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
        label.text = "Sign Up"
        label.font = UIFont(name: "Raleway-Bold", size: 30)
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
    
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Confirm Password"
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
        button.configureButton(title: "Log in", fontSize: 17, backgroundColor: .customBlue)
        button.layer.cornerRadius = 5
        
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
        button.setImage(UIImage(named: "google"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpConstraints()
    }
    
    private func setUpUI() {
        view.addSubview(backgroundImage)
        view.addSubview(viewForFields)
        view.addSubview(backButton)
        viewForFields.addSubview(logInLabel)
        viewForFields.addSubview(mailTextField)
        viewForFields.addSubview(passwordTextField)
        viewForFields.addSubview(confirmPasswordTextField)
        viewForFields.addSubview(signUpButton)
        viewForFields.addSubview(orLabel)
        viewForFields.addSubview(loginWithGoogle)
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
            passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 20),
            passwordTextField.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            passwordTextField.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            confirmPasswordTextField.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
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
