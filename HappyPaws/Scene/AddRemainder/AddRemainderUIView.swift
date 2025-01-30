//
//  AddRemainderUIView.swift
//  HappyPaws
//
//  Created by nino on 1/25/25.
//

import SwiftUI

struct AddReminderView: View {
    @ObservedObject var viewModel = AddReminderViewModel()
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var onReminderAdded: (() -> Void)?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }
                Section(header: Text("Notes")) {
                    TextField("Enter notes", text: $notes)
                }
                Section {
                    Toggle(isOn: $hasDueDate) {
                        Text("Set Due Date")
                    }
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                Button(action: saveReminder) {
                    Text("Save Reminder")
                }
            }
            .background(Color.white)
            .navigationTitle("Add Reminder")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveReminder() {
        let dueDateToSave = hasDueDate ? dueDate : nil
        viewModel.addReminder(title: title, notes: notes, dueDate: dueDateToSave) { success in
            if success {
                onReminderAdded?()
                presentationMode.wrappedValue.dismiss()
            } else {
                print("Failed to save reminder.")
            }
        }
    }
}


#Preview {
    AddReminderView()
}
