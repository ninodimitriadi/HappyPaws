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
    @Environment(\.presentationMode) var presentationMode
    @State private var bookingMessage: String = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Choose Appointment Time")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                DatePicker("Select Date & Time", selection: $viewModel.selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()

                Button("Confirm Booking") {
                    confirmBooking()
                }
                .padding()
                .frame(width: 200, height: 50)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 20)
            }
            .navigationBarTitle("Book Grooming", displayMode: .inline)
            .navigationBarItems(leading: Button("Close") {
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
