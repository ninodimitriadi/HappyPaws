//
//  CustomDoctorUiView.swift
//  HappyPaws
//
//  Created by nino on 1/18/25.
//

import SwiftUI

struct CustomDoctorUiView: View {
    var doctor: DoctorModel
    @EnvironmentObject private var languageManager: LanguageManager
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: doctor.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 90, height: 90)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                        .padding(10)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .cornerRadius(16)
                        .clipped()
                        .padding(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                        .clipped()
                        .padding(10)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(doctor.name)")
                        .font(Font.custom("Poppins-Regular", size: 15))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    Spacer()
                    Text("⭐️ \(String(format: "%.1f", doctor.rating))")
                        .font(Font.custom("Poppins-Regular", size: 13))
                        .foregroundStyle(.black)
                }
                Text("\(doctor.status)")
                    .font(Font.custom("Poppins-LightItalic", size: 15))
                    .foregroundStyle(.black)
                Text("\(languageManager.localizedString(forKey: "experience")): \(doctor.experience) \(languageManager.localizedString(forKey: "year"))")
                    .font(Font.custom("Poppins-Regular", size: 15))
                    .foregroundStyle(.black)
            }
            .padding(17)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
    }
}

#Preview {
    CustomDoctorUiView(
        doctor: DoctorModel(
            id: "1",
            name: "Dr. Laura Williams",
            status: "Senior Surgeon",
            experience: 12,
            phoneNimber: "+995 555 246 810",
            image: "https://firebasestorage.googleapis.com/v0/b/happypaws-f5ad3.firebasestorage.app/o/doctors%2Fsalome.avif?alt=media&token=57f0aba9-f818-4af2-b8c8-f0892cc5df72",
            info: "Very good doctor",
            rating: 4.9
        )
    )
}
