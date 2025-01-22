//
//  UserModel.swift
//  HappyPaws
//
//  Created by nino on 1/14/25.
//

import Foundation

struct UserModel {
    let uID: String
    let userName: String
    let email: String
    let profileImage: URL?
    var pets: [PetModel] = []
}
