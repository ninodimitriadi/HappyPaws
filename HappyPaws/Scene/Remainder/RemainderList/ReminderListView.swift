//
//  ReminderListView.swift
//  HappyPaws
//
//  Created by nino on 1/25/25.
//


import SwiftUI

struct ReminderListView: View {
    @StateObject private var viewModel = ReminderViewModel()
    @State private var showingAddReminderView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.reminders) { reminder in
                    VStack(alignment: .leading) {
                        Text(reminder.title)
                            .font(.headline)
                        if let dueDate = reminder.dueDate {
                            Text("Due: \(dueDate, formatter: dateFormatter)")
                                .font(.subheadline)
                        }
                        if let notes = reminder.notes {
                            Text(notes)
                                .font(.body)
                        }
                    }
                }
                .onDelete(perform: deleteReminder)
            }
            .navigationTitle("Reminders")
            .navigationBarItems(trailing: Button(action: {
                showingAddReminderView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddReminderView) {
                AddReminderView(viewModel: viewModel)
            }
        }
    }

    private func deleteReminder(at offsets: IndexSet) {
        offsets.forEach { index in
            let reminder = viewModel.reminders[index]
            viewModel.deleteReminder(withId: reminder.id) { success in
                if !success {
                    print("Failed to delete reminder.")
                }
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}
