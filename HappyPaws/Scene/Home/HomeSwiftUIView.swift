//
//  HomeSwiftUIView.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import SwiftUI

struct HomeSwiftUIView: View {
    
    @State private var isAddPetPagePresented = false
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var languageManager: LanguageManager

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isAddPetPagePresented.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.darkRed)
                    }
                    .padding()
                    .sheet(isPresented: $isAddPetPagePresented) {
                        AddPetUIView(onPetAdded: {
                            viewModel.fetchPets()
                        })
                        .environmentObject(languageManager)
                    }
                }
                AdvertisementCarouselView()
                HStack {
                    Text(languageManager.localizedString(forKey: "my_pets"))
                        .font(.custom("BebasNeue-Regular", size: 35))
                        .fontWeight(.bold)
                        .foregroundColor(Color.darkRed)
                        .padding(.leading, 25)
                    Spacer()
                }
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.pets, id: \.name) { pet in
                            NavigationLink(destination: PetProfileUIView(pet: pet).environmentObject(languageManager)) {
                                PetCardView(pet: pet)
                            }
                        }
                    }
                    .padding(15)
                }
            }
            .background(Color.backgroundGray)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchPets()
        }
    }
}

#Preview {
    HomeSwiftUIView()
}

