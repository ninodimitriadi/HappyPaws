//
//  AddPetUIView.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import SwiftUI
import PhotosUI

struct AddPetUIView: View {
    @StateObject private var viewModel = AddPetViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.dismiss) private var dismiss
    var onPetAdded: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.backgroundGray
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 20) {
                    PhotosPicker(
                        selection: $viewModel.selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 120, height: 120)
                                .shadow(radius: 5)
                            if let selectedImageData = viewModel.selectedImageData,
                               let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 110, height: 110)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 30)
                    }
                    ScrollView {
                        VStack(spacing: 16) {
                            CustomTextField(placeholder: languageManager.localizedString(forKey: "pet_name"), text: $viewModel.petName)
                            CustomTextField(placeholder: languageManager.localizedString(forKey: "pet_breed"), text: $viewModel.petBreed)
                            CustomTextField(placeholder: languageManager.localizedString(forKey: "pet_age"), text: $viewModel.petAge, keyboardType: .numberPad)
                            GenderPicker(selectedGender: $viewModel.petGender)
                            CustomTextField(placeholder: languageManager.localizedString(forKey: "pet_weight_kg"), text: $viewModel.petWeight, keyboardType: .decimalPad)
                            CustomTextField(placeholder: languageManager.localizedString(forKey: "pet_height_cm"), text: $viewModel.petHeight, keyboardType: .decimalPad)
                            CustomTextField(placeholder: languageManager.localizedString(forKey: "pet_color"), text: $viewModel.petColor)
                        }
                        .padding(.horizontal, 10)
                        Button(action: {
                            viewModel.savePet { success in
                                if success {
                                    onPetAdded?()
                                    dismiss()
                                }
                            }
                        }) {
                            Text(languageManager.localizedString(forKey: "save_pet"))
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("MainYellow"))
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
                    .padding()
                }
            }
        }
    }
}
