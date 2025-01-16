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
                        isAddPetPagePresented.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.roilaBlue)
                    }
                    .padding()
                    .sheet(isPresented: $isAddPetPagePresented) {
                        AddPetUIView(onPetAdded: {
                            viewModel.fetchPets() 
                        })
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.pets, id: \.name) { pet in
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
        .onAppear {
            viewModel.fetchPets()
        }
    }
}

#Preview {
    HomeSwiftUIView()
}

