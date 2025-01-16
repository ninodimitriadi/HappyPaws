//
//  AddPetViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/16/25.
//

import Foundation
import PhotosUI
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AddPetViewModel: ObservableObject {
    @Published var petName: String = ""
    @Published var petBreed: String = ""
    @Published var petAge: String = ""
    @Published var petGender: Gender = .male
    @Published var petWeight: String = ""
    @Published var petHeight: String = ""
    @Published var petColor: String = ""
    @Published var imageName: String = ""
    @Published var selectedImageData: Data? = nil
    @Published var selectedItem: PhotosPickerItem? = nil {
        didSet {
            handleImageSelection()
        }
    }
    
    private let storage = Storage.storage()
    
    func savePet(completion: @escaping (Bool) -> Void) {
        guard let age = Int(petAge),
              let weight = Int(petWeight),
              let height = Int(petHeight) else {
            print("Please enter valid numeric values for age, weight, and height.")
            completion(false)
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in")
            completion(false)
            return
        }

        var imageURL: String = ""
        if let selectedImageData = selectedImageData {
            uploadImageToFirebaseStorage(imageData: selectedImageData) { url in
                if let url = url {
                    imageURL = url
                } else {
                    print("Error uploading image")
                    completion(false)
                    return
                }
                
                let newPet = PetModel(
                    name: self.petName,
                    breed: self.petBreed,
                    age: age,
                    gender: self.petGender,
                    imageName: imageURL,
                    weight: weight,
                    height: height,
                    color: self.petColor
                )
                
                let petData: [String: Any] = [
                    "name": newPet.name,
                    "breed": newPet.breed,
                    "age": newPet.age,
                    "gender": newPet.gender.rawValue,
                    "imageName": newPet.imageName,
                    "weight": newPet.weight,
                    "height": newPet.height,
                    "color": newPet.color
                ]
                
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(userID)
                
                userRef.updateData([
                    "pets": FieldValue.arrayUnion([petData])
                ]) { error in
                    if let error = error {
                        print("Error saving pet: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Pet successfully added!")
                        completion(true)
                    }
                }
            }
        } else {
            let newPet = PetModel(
                name: petName,
                breed: petBreed,
                age: age,
                gender: petGender,
                imageName: "petDefault",
                weight: weight,
                height: height,
                color: petColor
            )
            
            let petData: [String: Any] = [
                "name": newPet.name,
                "breed": newPet.breed,
                "age": newPet.age,
                "gender": newPet.gender.rawValue,
                "imageName": newPet.imageName,
                "weight": newPet.weight,
                "height": newPet.height,
                "color": newPet.color
            ]
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)
            
            userRef.updateData([
                "pets": FieldValue.arrayUnion([petData])
            ]) { error in
                if let error = error {
                    print("Error saving pet: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Pet successfully added!")
                    completion(true)
                }
            }
        }
    }
    
    func uploadImageToFirebaseStorage(imageData: Data, completion: @escaping (String?) -> Void) {
        let storageRef = storage.reference().child("pet_images/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let downloadURL = url {
                    print("Image uploaded successfully! Download URL: \(downloadURL)")
                    completion(downloadURL.absoluteString)
                }
            }
        }
    }

    private func handleImageSelection() {
        Task {
            if let selectedItem = selectedItem {
                do {
                    if let data = try await selectedItem.loadTransferable(type: Data.self) {
                        DispatchQueue.main.async {
                            self.selectedImageData = data
                        }
                    }
                } catch {
                    print("Error loading photo: \(error.localizedDescription)")
                }
            }
        }
    }
}
