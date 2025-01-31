//
//  LogInViewController.swift
//  HappyPaws
//
//  Created by nino on 1/13/25.
//

import UIKit
import SwiftUICore
import SwiftUI
import GoogleSignIn
import FirebaseCore

class LogInViewController: UIViewController {
    
    private let viewModel = LogInViewModel()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "LogInBackground")
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
    
    private var logInLabel: UILabel = {
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
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.configureButton(title: "", fontSize: 17, backgroundColor: .customBlue)
        button.layer.cornerRadius = 5
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.pressLogInButton(button: button)
        }), for: .touchUpInside)
        return button
    }()

    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.configureButton(title: "", fontSize: 13, titleColor: .customBlue, font: "Raleway-Regular")
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(ForgetPasswordViewController(), animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.configureButton(title: "", fontSize: 13, titleColor: .customBlue, font: "Raleway-Regular")
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(SignUpViewController(), animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpConstraints()
        reloadUIForNewLanguage()
    }
    
    private func setUpUI() {
        view.addSubview(backgroundImage)
        view.addSubview(viewForFields)
        view.addSubview(activityIndicator)
        viewForFields.addSubview(logInLabel)
        viewForFields.addSubview(mailTextField)
        viewForFields.addSubview(passwordTextField)
        viewForFields.addSubview(loginButton)
        viewForFields.addSubview(forgetPasswordButton)
        viewForFields.addSubview(orLabel)
        viewForFields.addSubview(loginWithGoogle)
        viewForFields.addSubview(registerButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            viewForFields.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewForFields.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewForFields.heightAnchor.constraint(equalToConstant: 450),
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
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leftAnchor.constraint(equalTo: viewForFields.leftAnchor, constant: 30),
            loginButton.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            forgetPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            forgetPasswordButton.rightAnchor.constraint(equalTo: viewForFields.rightAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 16),
            orLabel.centerXAnchor.constraint(equalTo: viewForFields.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginWithGoogle.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20),
            loginWithGoogle.heightAnchor.constraint(equalToConstant: 46),
            loginWithGoogle.widthAnchor.constraint(equalToConstant: 46),
            loginWithGoogle.centerXAnchor.constraint(equalTo: viewForFields.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: loginWithGoogle.bottomAnchor, constant: 15),
            registerButton.centerXAnchor.constraint(equalTo: viewForFields.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func reloadUIForNewLanguage() {
        logInLabel.text = LanguageManager.shared.localizedString(forKey: "welcome_text")
        mailTextField.placeholder = LanguageManager.shared.localizedString(forKey: "email_address")
        passwordTextField.placeholder = LanguageManager.shared.localizedString(forKey: "password")
        loginButton.setTitle(LanguageManager.shared.localizedString(forKey: "log_in"), for: .normal)
        forgetPasswordButton.setTitle(LanguageManager.shared.localizedString(forKey: "forgotten_password"), for: .normal)
        orLabel.text = LanguageManager.shared.localizedString(forKey: "or_log_in")
        registerButton.setTitle(LanguageManager.shared.localizedString(forKey: "new_in"), for: .normal)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeIcon = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        if let eyeImageView = passwordTextField.rightView?.subviews.first as? UIImageView {
            eyeImageView.image = UIImage(systemName: eyeIcon)
        }
    }
    
    private func pressLogInButton(button: UIButton) {
        viewModel.email = mailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        
        activityIndicator.startAnimating()
        
        if !viewModel.validateFields() {
            activityIndicator.stopAnimating()
            if let emailError = viewModel.emailError {
                AlertManager.showBasicAlert(on: self, title: "Email Error", message: emailError)
            } else if let passwordError = viewModel.passwordError {
                AlertManager.showBasicAlert(on: self, title: "Password Error", message: passwordError)
            }
            return
        }
        
        viewModel.logIn { [weak self] success, error in
            self?.activityIndicator.stopAnimating()
            if success {
                self?.navigationController?.pushViewController(TabBarViewController(), animated: false)
                self?.navigationController?.setNavigationBarHidden(true, animated: false)
            } else {
                AlertManager.showBasicAlert(on: LogInViewController(), title: error ?? "Error", message: error?.description)
            }
        }
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

struct LogInViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> LogInViewController {
    return LogInViewController()
  }
  
  func updateUIViewController(_ uiViewController: LogInViewController, context: Context) {}
}

#Preview {
    LogInViewControllerWrapper()
}
