//
//  PetProfileViewModel.swift
//  HappyPaws
//
//  Created by nino on 1/17/25.
//

import Foundation
import FirebaseStorage
import SwiftUI

class PetProfileViewModel: ObservableObject {
    @Published var petImage: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let storage = Storage.storage()
    
    func fetchPetImage(imageURLString: String?) {
        guard let imageURLString = imageURLString, let imageURL = URL(string: imageURLString) else {
            errorMessage = "Invalid image URL"
            return
        }
        
        isLoading = true
        
        let storageRef = storage.reference(forURL: imageURL.absoluteString)
        
        storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Error fetching image from Firebase Storage: \(error.localizedDescription)"
                    print("Error fetching image from Firebase Storage: \(error.localizedDescription)")
                } else if let data = data, let uiImage = UIImage(data: data) {
                    self?.petImage = uiImage
                } else {
                    self?.errorMessage = "Failed to decode image data."
                    print("Failed to decode image data.")
                }
                
                self?.isLoading = false
            }
        }
    }
}
