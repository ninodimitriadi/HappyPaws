//
//  VetClinicDetailUIView.swift
//  HappyPaws
//
//  Created by nino on 1/18/25.
//

import SwiftUI

struct VetClinicDetailUIView: View {
    let clinic: ClinicModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.leading, 30)
                }
                Spacer()
            }
            Image(clinic.image)
                 .resizable()
                 .scaledToFit()
                 .frame(height: 200)
             
             // Clinic Title
             Text(clinic.title ?? "Clinic")
                 .font(.title)
                 .padding()

             // Address
             Text("Address: \(clinic.address)")
                 .font(.subheadline)
                 .padding()

             // Rating
             Text("Rating: ⭐️ \(clinic.rating)")
                 .font(.subheadline)
                 .padding()

             // Phone Number
             Text("Phone: \(clinic.clinicPhoneNumber)")
                 .font(.subheadline)
                 .padding()

             // Doctors list
             VStack {
                 Text("Doctors")
                     .font(.headline)
                 ForEach(clinic.doctors, id: \.name) { doctor in
                     VStack {
                         Text(doctor.name)
                             .font(.subheadline)
                         Text("Experience: \(doctor.experience) years")
                             .font(.subheadline)
                         Text("Status: \(doctor.status)")
                             .font(.subheadline)
                     }
                     .padding()
                 }
             }
         }
        .padding()
    }
}


//#Preview {
//    VetClinicDetailUIView()
//}
