//
//  DoctorProfileUIView.swift
//  HappyPaws
//
//  Created by nino on 1/18/25.
//

import SwiftUI

struct DoctorProfileUIView: View {
    
    var doctor: DoctorModel
    @StateObject private var viewModel = DoctorProfileViewModel()
    @State private var showBookingView = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            VStack {
                AsyncImage(url: URL(string: doctor.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                            .background(Color.gray.opacity(0.2))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    case .failure:
                        Color.gray
                            .frame(height: 300)
                            .overlay(
                                Text("No Image Available")
                                    .foregroundColor(.white)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(doctor.name)
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        Spacer()
                        Text("⭐️ \(doctor.rating, specifier: "%.1f")")
                            .font(Font.custom("Poppins-Regular", size: 15))
                            .foregroundStyle(.black)
                    }
                    .padding(.top, 12)
                    
                    Text(doctor.status)
                        .font(Font.custom("Poppins-Regular", size: 15))
                        .foregroundStyle(.gray)
                    
                    Text(doctor.phoneNimber)
                        .font(Font.custom("Poppins-Regular", size: 15))
                }
                .padding(.horizontal, 20)
                
                HStack(spacing: 50) {
                    RoundItemView(iconName: "briefcase.fill", value: "\(doctor.experience)+", label: languageManager.localizedString(forKey: "year"))
                    RoundItemView(iconName: "star.fill", value: "\(doctor.rating)", label: languageManager.localizedString(forKey: "rating"))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(languageManager.localizedString(forKey: "about_me"))
                        .font(Font.custom("Inter", size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    Text("\(doctor.info)")
                        .font(Font.custom("Inter", size: 14))
                        .foregroundStyle(.gray)
                }
                .padding(15)
                
                Button(action: {
                    showBookingView.toggle()
                }) {
                    Text(languageManager.localizedString(forKey: "book_appoimtment"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 298, height: 50)
                        .background(Color("MainYellow").opacity(0.8))
                        .cornerRadius(25)
                }
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                .padding(.top, 15)
                .sheet(isPresented: $showBookingView) {
                    BookDoctorAppointmentView(doctor: doctor, viewModel: viewModel)
                }
                
                Spacer()
            }
            .background(Color.backgroundGray)
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
    DoctorProfileUIView(
        doctor: DoctorModel(
            id: "!", name: "Dr. George Smith",
            status: "Surgeon",
            experience: 10,
            phoneNimber: "+995 555 123 456",
            image: "https://firebasestorage.googleapis.com/v0/b/happypaws-f5ad3.firebasestorage.app/o/doctors%2Fsalome.avif?alt=media&token=57f0aba9-f818-4af2-b8c8-f0892cc5df72",
            info: "კესო კერესელიძე #აიბოსგუნდის ფართო პროფილის ექიმი-ვეტერინარი და ინფექციონისტია.",
            rating: 4.6
        )
    )
}

