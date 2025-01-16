//
//  PetProfileUIView.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import SwiftUI

struct PetProfileUIView: View {
    
    var pet: PetModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = PetProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Image...")
                        .frame(height: 400)
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .padding(.top, 20)
                } else if let petImage = viewModel.petImage {
                    Image(uiImage: petImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                        .ignoresSafeArea()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 400)
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                        .ignoresSafeArea()
                }
                
                MainInfoUIView(pet: pet)
                    .padding(.horizontal)
                    .padding(.top, -155)
                    .background(
                        BlurView(style: .systemMaterial)
                            .opacity(0.55)
                            .cornerRadius(27)
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(.petPaw)
                            .frame(width: 27, height: 27)
                        Text("About \(pet.name)")
                            .font(Font.custom("Poppins-Bold", size: 19))
                    }
                    HStack {
                        InfoCardView(title: "Weight", value: "\(pet.weight) Kg")
                        InfoCardView(title: "Height", value: "\(pet.height) Cm")
                        InfoCardView(title: "Color", value: "\(pet.color)")
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle("")
        .onAppear {
            viewModel.fetchPetImage(imageURLString: pet.imageName) 
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.white)
            }
        }
    }
}



#Preview {
    PetProfileUIView(pet: PetModel(
        name: "Buddy",
        breed: "Golden Retriever",
        age: 3,
        gender: .male,
        imageName: "dog",
        weight: 30,
        height: 60,
        color: "white"
    ))
}


