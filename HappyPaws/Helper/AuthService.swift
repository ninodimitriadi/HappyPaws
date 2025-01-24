//
//  AuthService.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthService {
    
    public static let shared = AuthService()
    
    private init() {}
    
    public func registerUser(with userRequest: RegisterRequest, completion: @escaping (Bool, Error?)->Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let uid = resultUser.uid
            let db = Firestore.firestore()
            db.collection("users")
                .document(uid)
                .setData([
                    "uid": uid,
                    "username": username,
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    completion(true, nil)
                }
        }
    }
    
    public func signIn(with userRequest: LoginRequest, completion: @escaping (Error?)->Void) {
        Auth.auth().signIn(
            withEmail: userRequest.email,
            password: userRequest.password
        ) { result, error in
            if let error = error {
                completion(error)
                print(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    public func fetchUser(completion: @escaping (UserModel?, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil, NSError(domain: "AuthService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        let uid = currentUser.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let username = data["username"] as? String,
                  let email = data["email"] as? String else {
                completion(nil, NSError(domain: "AuthService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found"]))
                return
            }
            
            // Safely handle profileImageURL as an optional URL
            let profileImageURL = URL(string: data["profileImageURL"] as? String ?? "")
            
            // Safely handle pets data, skip invalid pets
            var pets: [PetModel] = []
            if let petsData = data["pets"] as? [[String: Any]] {
                // Use compactMap to skip invalid pets
                pets = petsData.compactMap { petDict in
                    guard let name = petDict["name"] as? String,
                          let breed = petDict["breed"] as? String,
                          let age = petDict["age"] as? Int,
                          let genderRaw = petDict["gender"] as? String,
                          let gender = Gender(rawValue: genderRaw),
                          let imageName = petDict["imageName"] as? String,
                          let weight = petDict["weight"] as? Int,
                          let height = petDict["height"] as? Int,
                          let color = petDict["color"] as? String else {
                        // Skip invalid pet
                        return nil
                    }
                    // Return a valid PetModel if all required fields are present
                    return PetModel(
                        name: name,
                        breed: breed,
                        age: age,
                        gender: gender,
                        imageName: imageName,
                        weight: weight,
                        height: height,
                        color: color
                    )
                }
            }
            
            // Now safely initialize UserModel
            let user = UserModel(uID: uid, userName: username, email: email, profileImage: profileImageURL, pets: pets)
            completion(user, nil)
        }
    }



    public func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil, NSError(domain: "AuthService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(currentUser.uid).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil, NSError(domain: "AuthService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"]))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                completion(url, nil)
            }
        }
    }
    
    public func updateProfileImageURL(_ url: URL, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(NSError(domain: "AuthService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).updateData(["profileImageURL": url.absoluteString]) { error in
            completion(error)
        }
    }
}
