//
//  UserProfileViewController.swift
//  HappyPaws
//
//  Created by nino on 1/20/25.
//

import UIKit
import SwiftUI

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var viewModel = UserProfileViewModel()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 4
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "user@example.com"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    private let remindersButton = createButton(title: "View Reminders", iconName: "calendar", backgroundColor: .mainYellow)
    
    private let resetPasswordButton = createButton(title: "Reset Password", iconName: "lock", backgroundColor: .mainYellow)
    
    private var languageButton = createButton(title: "Change Language 🇬🇪", iconName: "globe", backgroundColor: .mainYellow)
    private let logoutButton = createButton(title: "Logout", iconName: "arrow.backward", backgroundColor: .mainYellow)
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18
        return stackView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundGray
        setupUI()
        setUpConstraints()
        addTapGestureToProfileImage()
        bindViewModel()
        loadCurrentUser()
    }

    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(emailLabel)
        view.addSubview(buttonStackView)
        view.addSubview(saveButton)
        buttonStackView.addArrangedSubview(remindersButton)
        buttonStackView.addArrangedSubview(resetPasswordButton)
        buttonStackView.addArrangedSubview(languageButton)
        buttonStackView.addArrangedSubview(logoutButton)

        languageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        remindersButton.addTarget(self, action: #selector(navigateToReminder), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 60),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onImageUploaded = { [weak self] url in
            if let url = url {
                print("Image uploaded successfully: \(url)")
                self?.profileImageView.image = UIImage(contentsOfFile: url.absoluteString)
            } else {
                print("Image upload failed")
            }
        }

        viewModel.onError = { [weak self] error in
            print("Error: \(error.localizedDescription)")
            
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.onLogoutSuccess = { 
            let loginVC = LogInViewController()
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let navController = UINavigationController(rootViewController: loginVC)
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    private func addTapGestureToProfileImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func selectProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func changeLanguage() {
        if languageButton.title(for: .normal)?.contains("🇬🇪") == true {
            languageButton.setTitle("Change Language 🇺🇸", for: .normal)
        } else {
            languageButton.setTitle("Change Language 🇬🇪", for: .normal)
        }
    }
    
    @objc private func resetPassword() {
        let forgetPasswordVC = ForgetPasswordViewController()
        self.navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }
    
    @objc private func navigateToReminder() {
        let reminderListView = ReminderListView()
        let hostingController = UIHostingController(rootView: reminderListView)
        
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    @objc private func logout() {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "Do you really want to log out?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.logoutUser()
        }))
        
        present(alert, animated: true, completion: nil)
    }

    @objc private func saveProfile() {
        guard let image = profileImageView.image else {
            print("No image to upload")
            return
        }
        viewModel.uploadProfileImage(image)
        showSaveSuccessAlert()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
    }
    
    private func loadCurrentUser() {
        viewModel.fetchCurrentUser { [weak self] user in
            guard let user = user else {
                print("Failed to load user data")
                return
            }
            
            DispatchQueue.main.async {
                self?.usernameLabel.text = user.userName
                self?.emailLabel.text = user.email
                
                if let profileImageURL = user.profileImage {
                    self?.loadImage(from: profileImageURL)
                }
            }
        }
    }

    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }
        task.resume()
    }
    
    private func showSaveSuccessAlert() {
        showSaveSuccessView(massage: "Profile saved successfully!", parentView: view)
    }
}



struct UserProfileViewControllerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UserProfileViewController {
    return UserProfileViewController()
  }
  
  func updateUIViewController(_ uiViewController: UserProfileViewController, context: Context) {}
}

#Preview {
    UserProfileViewControllerWrapper()
}
