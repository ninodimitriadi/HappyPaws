//
//  PetCardView.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import SwiftUI

struct PetCardView: View {
    var pet: PetModel

    var body: some View {
        HStack {
            if let imageURL = URL(string: pet.imageName) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 120)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(16)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .cornerRadius(16)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(16)
                            .clipped()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(16)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(pet.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Image(pet.gender == .male ? "male" : "female")
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
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
    }
}

#Preview {
    PetCardView(pet: PetModel(
        name: "Buddy",
        breed: "Golden Retriever",
        age: 3,
        gender: .male,
        imageName: "petDefault", 
        weight: 30,
        height: 60,
        color: "white"
    ))
}
