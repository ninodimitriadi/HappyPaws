//
//  AddPetViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/16/25.
//


import Foundation
import PhotosUI
import SwiftUI

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
    
    func savePet() {
        guard let age = Int(petAge), let weight = Int(petWeight), let height = Int(petHeight) else {
            print("Please enter valid numeric values for age, weight, and height.")
            return
        }
        
        let newPet = PetModel(
            name: petName,
            breed: petBreed,
            age: age,
            gender: petGender,
            imageName: imageName,
            weight: weight,
            height: height,
            color: petColor
        )
        print("Pet saved: \(newPet)")
        // Add logic to save the pet to a database or backend if necessary
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
