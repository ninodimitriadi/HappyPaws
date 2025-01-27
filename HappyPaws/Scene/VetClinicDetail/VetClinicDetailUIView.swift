//
//  VetClinicDetailUIView.swift
//  HappyPaws
//
//  Created by nino on 1/18/25.
//

import SwiftUI
import CoreLocation

struct VetClinicDetailUIView: View {
    let clinic: ClinicModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    AsyncImage(url: URL(string: clinic.image)) { phase in
                        switch phase {
                        case .empty:
                            Color.gray
                                .frame(height: 200)
                                .overlay(
                                    ProgressView()
                                )
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                        case .failure:
                            Color.gray
                                .frame(height: 200)
                                .overlay(
                                    Text("Failed to load image")
                                        .foregroundColor(.white)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text(clinic.title ?? "Clinic")
                                    .font(Font.custom("Poppins-Bold", size: 24))
                                    .foregroundStyle(Color.black)
                                Spacer()
                                Text("⭐️ \(clinic.rating, specifier: "%.1f")")
                                    .font(.subheadline)
                            }

                            HStack {
                                Image("address")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 18)
                                Text(clinic.address)
                                    .font(.subheadline)
                            }
                            HStack {
                                Image("telephone")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 17)
                                Text(clinic.clinicPhoneNumber)
                                    .font(.subheadline)
                            }
                            
                            Text("Our Doctors")
                                .font(.headline)
                                .padding(.top, 10)
                        }
                        .padding(15)
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(clinic.doctors, id: \.phoneNimber) { doctor in
                                    NavigationLink(destination: DoctorProfileUIView(doctor: doctor)) {
                                        CustomDoctorUiView(doctor: doctor)
                                    }
                                }
                            }
                            .padding(15)
                        }
                    }
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                        .padding()
                        .padding(.top, 50)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}


#Preview {
    VetClinicDetailUIView(clinic: ClinicModel(
        address: "5 Freedom Square, Tbilisi, Georgia",
        coordinate: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
        title: "Tbilisi Vet Clinic",
        clinicPhoneNumber: "+995 599 123 456",
        rating: 4.5,
        doctors: [DoctorModel(id: "1", name: "Dr. George Smith", status: "Surgeon", experience: 10, phoneNimber: "+995 555 123 456", image: "doctor1", info: "very good doctot",  rating: 4.6), DoctorModel(id: "2", name: "Dr. George Smith", status: "Terapevt", experience: 10, phoneNimber: "+995 555 123 456", image: "doctor1", info: "very good doctot", rating: 5.0)],
        image: "vetClinic"
    ))
}
