//
//  PetCardView.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import SwiftUI

struct PetCardView: View {
    var petName: String = "Buddy"
    var petBreed: String = "Golden Retriever"
    var petAge: String = "3 Years"
    var petImage: String = "dog"
    var petGender: String = "Male"
    
    var pet = PetModel(name: "Buddy", breed: "Golden Retriever", age: 3, gender: .male, imageName: "dog", weight: 4, height: 42)
    
    var body: some View {
        HStack {
            Image(pet.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .cornerRadius(16)
                .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(pet.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(petGender == "Male" ? "male" : "female")
                      .resizable()
                      .scaledToFill()
                      .frame(width: 30, height: 30)
                      .padding(.trailing, 20)
                }
                Text(pet.breed)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(pet.age) Years")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

#Preview {
    PetCardView()
}
