//
//  HomeViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/16/25.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HomeViewModel: ObservableObject {
    @Published var pets: [PetModel] = []
    @Published var errorMessage: String? = nil
    
    private let authService = AuthService.shared
    private let storage = Storage.storage()
    
    init() {
        fetchPets()
    }
    
    func fetchPets() {
        authService.fetchUser { [weak self] user, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let user = user {
                    self?.loadPetImages(for: user.pets)
                } else {
                    self?.errorMessage = "Failed to fetch user data."
                }
            }
        }
    }
    
    private func loadPetImages(for pets: [PetModel]) {
           var updatedPets = pets
           
           let dispatchGroup = DispatchGroup()
           for (index, pet) in pets.enumerated() {
               dispatchGroup.enter()
               
               let imageRef = storage.reference().child("pet_images/\(pet.imageName)")
               imageRef.downloadURL { url, error in
                   DispatchQueue.main.async {
                       if let error = error {
                           print("Error fetching image URL for pet '\(pet.name)': \(error.localizedDescription)")
                       } else if let url = url {
                           updatedPets[index].imageName = url.absoluteString
                       }
                       dispatchGroup.leave()
                   }
               }
           }
           
           dispatchGroup.notify(queue: .main) {
               self.pets = updatedPets
           }
       }
}
