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
    @EnvironmentObject var languageManager: LanguageManager
    var onReminderAdded: (() -> Void)?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(languageManager.localizedString(forKey: "title"))) {
                    TextField(languageManager.localizedString(forKey: "enter_title"), text: $title)
                }
                Section(header: Text(languageManager.localizedString(forKey: "note"))) {
                    TextField(languageManager.localizedString(forKey: "enter_note"), text: $notes)
                }
                Section {
                    Toggle(isOn: $hasDueDate) {
                        Text(languageManager.localizedString(forKey: "set_deu_date"))
                    }
                    if hasDueDate {
                        DatePicker(languageManager.localizedString(forKey: "due_date"), selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                Button(action: saveReminder) {
                    Text(languageManager.localizedString(forKey: "save_reminder"))
                }
            }
            .background(Color.white)
            .navigationTitle(languageManager.localizedString(forKey: "add_a_reminder"))
            .navigationBarItems(trailing: Button(languageManager.localizedString(forKey: "cancle")) {
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
