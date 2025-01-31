//
//  UserProfileViewController.swift
//  HappyPaws
//
//  Created by nino on 1/20/25.
//

import UIKit
import SwiftUI
import Firebase
import PhotosUI
import Combine

class UserProfileViewController: UIViewController {
    
    private var viewModel = UserProfileViewModel()
    private var reminderViewModel = AddReminderViewModel()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 27
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.tintColor = .black
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dashboardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        stackView.layer.shadowColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        stackView.layer.shadowOffset = CGSize(width: 0, height: 22.9)
        stackView.layer.shadowOpacity = 1.0
        stackView.layer.shadowRadius = 11.45
        stackView.layer.masksToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dashboardName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let resetButton = createButton(iconName: "lock")
    
    private let changeLanguageButton = createButton(iconName: "gear")
    
    private let addReminderButton = createButton(iconName: "square.and.pencil")
    
    private let reminderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 36)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var remindersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 270, height: 130)
        layout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 20)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchReminders()
        setupUI()
        setupCollectionView()
        setupStackView()
        bindViewModel()
        addButtonTarget()
        loadCurrentUser()
        addTapGestureToProfileImage()
        
        viewModel.onRemindersUpdated = { [weak self] in
            self?.remindersCollectionView.reloadData()
        }
        
        reminderViewModel.onReminderAdded = { [weak self] in
            self?.viewModel.fetchReminders()
        }
        
        reloadUIForNewLanguage()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let headerView = UIView()
        headerView.backgroundColor = .darkBlue.withAlphaComponent(0.9)
        headerView.layer.cornerRadius = 40
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        headerView.addSubview(profileImageView)
        headerView.addSubview(nameLabel)
        
        view.addSubview(dashboardStackView)
        
        view.addSubview(reminderLabel)
        
        view.addSubview(remindersCollectionView)
        view.addSubview(logoutButton)
        
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 319),
            
            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            
            dashboardStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 28),
            dashboardStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dashboardStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            dashboardStackView.heightAnchor.constraint(equalToConstant: 166),
            
            reminderLabel.topAnchor.constraint(equalTo: dashboardStackView.bottomAnchor, constant: 35),
            reminderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            remindersCollectionView.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor),
            remindersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            remindersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            remindersCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            logoutButton.topAnchor.constraint(equalTo: remindersCollectionView.bottomAnchor, constant: 45),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupStackView() {
        dashboardStackView.addArrangedSubview(dashboardName)
        dashboardStackView.addArrangedSubview(resetButton)
        dashboardStackView.addArrangedSubview(changeLanguageButton)
        dashboardStackView.addArrangedSubview(addReminderButton)
        
        dashboardStackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        dashboardStackView.isLayoutMarginsRelativeArrangement = true
    }

    private func setupCollectionView() {
        remindersCollectionView.delegate = self
        remindersCollectionView.dataSource = self
        remindersCollectionView.register(ReminderCell.self, forCellWithReuseIdentifier: ReminderCell.reuseIdentifier)
    }
    
    private func addButtonTarget() {
        resetButton.addTarget(self, action: #selector(resetPasswordTapped), for: .touchUpInside)
        changeLanguageButton.addTarget(self, action: #selector(changeLanguageTapped), for: .touchUpInside)
        addReminderButton.addTarget(self, action: #selector(addReminderTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveProfileTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.onImageUploaded = { [weak self] url in
            if let url = url {
                self?.loadImage(from: url)
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
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func selectProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func saveProfileTapped() {
        guard let image = profileImageView.image else {
            print("No image to upload")
            return
        }
        viewModel.uploadProfileImage(image)
        showSaveSuccessAlert()
    }
    
    @objc private func resetPasswordTapped() {
        let forgetPasswordVC = ForgetPasswordViewController()
        self.navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }
    
    @objc private func changeLanguageTapped() {
        let alert = UIAlertController(title: "Change Language", message: "Select a language", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "English", style: .default, handler: { _ in
            self.setLanguage("en")
        }))
        
        alert.addAction(UIAlertAction(title: "ქართული", style: .default, handler: { _ in
            self.setLanguage("ka")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setLanguage(_ languageCode: String) {
        LanguageManager.shared.setLanguage(languageCode)
        reloadUIForNewLanguage()
    }
    
    private func reloadUIForNewLanguage() {
        print("Reloading UI for Language: \(LanguageManager.shared.currentLanguage)")
        
        // Update all UI elements with localized strings
        dashboardName.text = LanguageManager.shared.localizedString(forKey: "dashboard")
        resetButton.setTitle(LanguageManager.shared.localizedString(forKey: "reset_password"), for: .normal)
        changeLanguageButton.setTitle(LanguageManager.shared.localizedString(forKey: "change_language"), for: .normal)
        addReminderButton.setTitle(LanguageManager.shared.localizedString(forKey: "add_reminder"), for: .normal)
        reminderLabel.text = LanguageManager.shared.localizedString(forKey: "reminders")
        logoutButton.setTitle(LanguageManager.shared.localizedString(forKey: "log_out"), for: .normal)
        saveButton.setTitle(LanguageManager.shared.localizedString(forKey: "save"), for: .normal)
        
        remindersCollectionView.reloadData()
    }
    
    @objc private func addReminderTapped() {
        let addReminderView = AddReminderView(onReminderAdded: { [weak self] in
            self?.viewModel.fetchReminders()
        })
        let hostingController = UIHostingController(rootView: addReminderView.environmentObject(LanguageManager.shared))
        self.present(hostingController, animated: true, completion: nil)
    }
    
    @objc private func logOutTapped() {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "Do you really want to log out?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.logoutUser()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func loadCurrentUser() {
        viewModel.fetchCurrentUser { [weak self] user in
            guard let user = user else {
                print("Failed to load user data")
                return
            }
            
            DispatchQueue.main.async {
                self?.nameLabel.text = user.userName
                
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
    
    private func reloadReminders() {
        DispatchQueue.main.async {
            self.remindersCollectionView.reloadData()
        }
    }
}

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reminders.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReminderCell.reuseIdentifier, for: indexPath) as? ReminderCell else {
            fatalError("Could not dequeue a cell of type ReminderCell.")
        }

        let reminder = viewModel.reminders[indexPath.item]
        
        if let dueDateComponents = reminder.dueDateComponents {
            let dueDate = Calendar.current.date(from: dueDateComponents)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            let formattedDate = dueDate != nil ? dateFormatter.string(from: dueDate!) : "No Date"
            
            cell.configure(title: reminder.title, date: formattedDate, notes: reminder.notes ?? "No Notes")
        } else {
            cell.configure(title: reminder.title, date: "No Date", notes: reminder.notes ?? "No Notes")
        }
        
        cell.onDeleteReminder = { [weak self] in
            self?.deleteReminder(at: indexPath)
        }
        
        return cell
    }

    func deleteReminder(at indexPath: IndexPath) {
        viewModel.deleteReminder(at: indexPath.item)
    }
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            viewModel.uploadProfileImage(selectedImage)
        }
        dismiss(animated: true, completion: nil)
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
