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
    @State private var isAddRemainderPresented = false
    
    var body: some View {
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
                .padding(.top, -200)
                .background(
                    BlurView(style: .systemMaterial)
                        .opacity(0.55)
                        .cornerRadius(27)
                )
            
            VStack(alignment: .leading) {
                HStack {
                    Image("petPaw")
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
            .padding(.top, -40)
    
            HStack {
                Button(action: {
                    isAddRemainderPresented.toggle()
                    print("reminde")
                }) {
                    HStack {
                        Image("addremainder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                        Text("Add a Reminder")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.black)
                    }
                    .frame(width: 300, height: 50)
                    .background(Color.mainYellow)
                    .cornerRadius(25)
                    .contentShape(Rectangle())
                }
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                .sheet(isPresented: $isAddRemainderPresented) {
                    AddReminderView()
                }
            }
            .padding(.top, 80)
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchPetImage(imageURLString: pet.imageName)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading: backButton)
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
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


