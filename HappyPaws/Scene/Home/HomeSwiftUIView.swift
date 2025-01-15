//
//  HomeSwiftUIView.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import SwiftUI

struct HomeSwiftUIView: View {
    let pets = [
        PetModel(
            name: "Buddy",
            breed: "Golden Retriever",
            age: 3,
            gender: .male,
            imageName: "dog",
            weight: 30,
            height: 60,
            color: "white"
        ),
        PetModel(
            name: "Bella",
            breed: "Labrador Retriever",
            age: 2,
            gender: .female,
            imageName: "dog",
            weight: 25,
            height: 55,
            color: "Black"
        ),
        PetModel(
            name: "Max",
            breed: "Beagle",
            age: 4,
            gender: .male,
            imageName: "dog",
            weight: 20,
            height: 50,
            color: "Wight"
        ),
        PetModel(
            name: "Lucy",
            breed: "Poodle",
            age: 5,
            gender: .female,
            imageName: "dog",
            weight: 22,
            height: 45,
            color: "Ginger"
        )
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("My Pets")
                        .font(Font.custom("Roboto-Bold", size: 35))
                        .fontWeight(.bold)
                        .foregroundColor(.roilaBlue)
                    Spacer()
                    Button(action: {
                        print("Add new pet tapped!")
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.roilaBlue)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(pets, id: \.name) { pet in
                            NavigationLink(destination: PetProfileUIView(pet: pet)) {
                                PetCardView(pet: pet)
                            }
                        }
                    }
                    .padding(15)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeSwiftUIView()
}

