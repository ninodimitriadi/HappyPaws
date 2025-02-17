//
//  PetModel.swift
//  HappyPaws
//
//  Created by nino on 1/15/25.
//

import Foundation

struct PetModel {
    var name: String
    var breed: String
    var age: Int
    var gender: Gender
    var imageName: String
    var weight: Int
    var height: Int
    var color: String
}

enum Gender: String, CaseIterable {
    case female = "Female"
    case male = "Male"
}
