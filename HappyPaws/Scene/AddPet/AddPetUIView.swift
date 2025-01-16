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
    @Environment(\.dismiss) private var dismiss
    var onPetAdded: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.mainYellow
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
                            CustomTextField(placeholder: "Pet Name", text: $viewModel.petName)
                            CustomTextField(placeholder: "Pet Breed", text: $viewModel.petBreed)
                            CustomTextField(placeholder: "Pet Age", text: $viewModel.petAge, keyboardType: .numberPad)
                            GenderPicker(selectedGender: $viewModel.petGender)
                            CustomTextField(placeholder: "Pet Weight (kg)", text: $viewModel.petWeight, keyboardType: .decimalPad)
                            CustomTextField(placeholder: "Pet Height (cm)", text: $viewModel.petHeight, keyboardType: .decimalPad)
                            CustomTextField(placeholder: "Pet Color", text: $viewModel.petColor)
                        }
                        .padding(.horizontal, 20)
                        Button(action: {
                            viewModel.savePet { success in
                                if success {
                                    onPetAdded?()
                                }
                            }
                        }) {
                            Text("Save Pet")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
    }
}
