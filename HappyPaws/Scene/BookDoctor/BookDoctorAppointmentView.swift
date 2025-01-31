//
//  BookAppointmentView.swift
//  HappyPaws
//
//  Created by nino on 1/27/25.
//

import SwiftUI

struct BookDoctorAppointmentView: View {
    var doctor: DoctorModel
    @ObservedObject var viewModel: DoctorProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var bookingMessage: String = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Text(languageManager.localizedString(forKey: "choose_appointment_time"))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                DatePicker("Select Date & Time", selection: $viewModel.selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .environment(\.locale, Locale(identifier: languageManager.currentLanguage))
                    .padding()

                Button(languageManager.localizedString(forKey: "confirm_booking")) {
                    confirmBooking()
                }
                .padding()
                .frame(width: 200, height: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 20)
            }
            .navigationBarTitle(languageManager.localizedString(forKey: "book_appoimtment"), displayMode: .inline)
            .navigationBarItems(leading: Button(languageManager.localizedString(forKey: "close")) {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Booking Status"), message: Text(bookingMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func confirmBooking() {
        viewModel.bookAppointment(for: doctor.id, startTime: viewModel.selectedDate) { success, message in
            bookingMessage = message
            showAlert = true
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

