//
//  BookGroomingAppointmentView.swift
//  HappyPaws
//
//  Created by nino on 1/29/25.
//


import SwiftUI

struct BookGroomingAppointmentView: View {
    var salon: GroomingSalonModel
    @ObservedObject var viewModel: GroomingDetailsViewModel
    @EnvironmentObject private var languageManager: LanguageManager
    @Environment(\.presentationMode) var presentationMode
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
                .background(Color("MainYellow").opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 20)
            }
            .navigationBarTitle(languageManager.localizedString(forKey: "book_Grooming"), displayMode: .inline)
            .navigationBarItems(leading: Button(languageManager.localizedString(forKey: "close")) {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Booking Status"), message: Text(bookingMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func confirmBooking() {
        viewModel.bookGroomingAppointment(for: salon.placeID, startTime: viewModel.selectedDate) { success, message in
            bookingMessage = message
            showAlert = true
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }}
