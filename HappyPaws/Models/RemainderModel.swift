//
//  RemainderModel.swift
//  HappyPaws
//
//  Created by nino on 1/25/25.
//

import Foundation

struct RemainderModel: Identifiable {
    let id: String
    let title: String
    let notes: String?
    let dueDate: Date?
}
