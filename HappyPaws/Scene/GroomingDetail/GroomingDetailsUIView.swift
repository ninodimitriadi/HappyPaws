//
//  GroomingDetailsUIView.swift
//  HappyPaws
//
//  Created by nino on 1/23/25.
//

import SwiftUI
import Foundation
import CoreLocation

struct GroomingDetailsUIView: View {
    @Environment(\.presentationMode) var presentationMode
    let viewModel = GroomingDetailsViewModel()
    @EnvironmentObject private var languageManager: LanguageManager
    var salon: GroomingSalonModel
    var salonDetail: SalonDetailsModel
    @State private var showBookingView = false
    
    var body: some View {
        VStack {
            Image("groomingBackground")
                .resizable()
                .scaledToFit()
                .frame(width: 600, height: 600)
                .clipShape(.circle)
            
            VStack(spacing: 14) {
                HStack {
                    Text(salon.name)
                        .font(Font.custom("Inter", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                    StarRatingView(rating: salon.rating)
                }
                
                HStack {
                    Image("address")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text(salonDetail.address)
                        .font(.subheadline)
                    Spacer()
                }
                
                HStack {
                      Image("telephone")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 20, height: 20)
                      Text(salonDetail.phoneNumber)
                          .font(.subheadline)
                      Spacer()
                  }
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text(languageManager.localizedString(forKey: "opening_hours"))
                                .font(.headline)
                        }
                        
                        if let openingHours = salonDetail.openingHours {
                            ForEach(viewModel.formatOpeningHours(openingHours), id: \.self) { hours in
                                Text(hours)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.top, 6)
                            }
                        } else {
                            Text("N/A")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top, 19)
            .padding(.leading, 23)
            .padding(.trailing, 23)
            
            HStack {
                SmallRoundViewWithText(icon: "scissors", text: languageManager.localizedString(forKey: "hairstyle"))
                SmallRoundViewWithText(icon: "shower.fill", text: languageManager.localizedString(forKey: "washing_brushing"))
                SmallRoundViewWithText(icon: "ladybug", text: languageManager.localizedString(forKey: "removal_of_parasites"))
            }
            .padding(.top, 15)
            
            Button(action: {
                showBookingView.toggle()
            }) {
                Text(languageManager.localizedString(forKey: "book_appoimtment"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 298, height: 50)
                    .background(Color.mainYellow)
                    .cornerRadius(25)
            }
            .sheet(isPresented: $showBookingView) {
                BookGroomingAppointmentView(salon: salon, viewModel: GroomingDetailsViewModel())
            }
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
            .padding(50)
            
            Spacer(minLength: 400)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle("")
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
    GroomingDetailsUIView(salon: GroomingSalonModel(placeID: "", name: "Grooming Cool", coordinate: CLLocationCoordinate2D(latitude: 2.33, longitude: 3.33), phoneNumber: "599 66 77 88", rating: 4.9), salonDetail: SalonDetailsModel(address: "Guramishvili av", phoneNumber: "599 66 77 88", website: "Grooming.com", openingHours: ["10:00", "19:00"]))
}
