//
//  MainInfoUIView.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import SwiftUI

struct MainInfoUIView: View {
    
    var pet: PetModel
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(pet.name)
                    .font(Font.custom("Poppins-Bold", size: 26))
                    .foregroundStyle(.black)
                Text("\(pet.breed) • \(pet.age) Year ")
                    .font(Font.custom("Poppins-Regular", size: 17))
                    .foregroundStyle(.gray)
                    .frame(alignment: .leading)
            }
            .padding(22)
            .frame(alignment: .leading)
            Spacer()
            VStack {
                Image(pet.gender == .male ? "male" : "female")
                  .resizable()
                  .scaledToFill()
                  .frame(width: 21, height: 21)
                  .padding(9)
            }
            .background(Color.mainYellow)
            .cornerRadius(9)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            BlurView(style: .systemMaterialLight)
                .opacity(1)
                .cornerRadius(27)
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5.5)
    }
}

#Preview {
    MainInfoUIView(pet: PetModel(
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
