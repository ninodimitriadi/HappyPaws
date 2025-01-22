//
//  UserProfileViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/20/25.
//


import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UserProfileViewModel {
    var onImageUploaded: ((URL?) -> Void)?
    var onError: ((Error) -> Void)?
    var onLogoutSuccess: (() -> Void)?

    func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Unable to convert image to data")
            return
        }
        
        let fileName = "\(Auth.auth().currentUser?.uid ?? "unknown_user")_profile.jpg"
        let storageRef = Storage.storage().reference().child("profile_images").child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                self?.onImageUploaded?(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve download URL: \(error.localizedDescription)")
                    self?.onImageUploaded?(nil)
                    return
                }
                
                if let url = url {
                    self?.updateUserProfileImageURL(url)
                }
            }
        }
    }

    
    private func updateUserProfileImageURL(_ url: URL) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in")
            return
        }

        let userDocRef = Firestore.firestore().collection("users").document(userID)
        
        userDocRef.setData(["profileImage": url.absoluteString], merge: true) { [weak self] error in
            if let error = error {
                print("Failed to update Firestore: \(error.localizedDescription)")
                self?.onError?(error)
            } else {
                print("Profile image URL updated successfully")
                self?.onImageUploaded?(url)
            }
        }
    }
    
    func fetchCurrentUser(completion: @escaping (UserModel?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).getDocument { document, error in
            if let error = error {
                print("Failed to fetch user: \(error.localizedDescription)")
                completion(nil)
            } else {
                guard let document = document, document.exists else {
                    print("User document does not exist")
                    completion(nil)
                    return
                }
                
                // Assuming the user data has these fields
                let userName = document.get("username") as? String ?? "Unknown"
                let email = document.get("email") as? String ?? "No email"
                let profileImageURLString = document.get("profileImage") as? String
                let profileImageURL = profileImageURLString.flatMap { URL(string: $0) }
                
                let user = UserModel(uID: currentUser.uid, userName: userName, email: email, profileImage: profileImageURL)
                
                completion(user)
            }
        }
    }

    func logoutUser() {
        AuthService.shared.signOut { [weak self] error in
            if let error = error {
                self?.onError?(error)
            } else {
                self?.onLogoutSuccess?()
            }
        }
    }
}



