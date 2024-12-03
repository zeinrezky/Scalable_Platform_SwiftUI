//
//  UserJSON.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import Foundation

enum GenderEnum: Int, Codable {
    case female = 0
    case male = 1
}

struct UserJSON: Codable {
    var uid: String?
    var email: String?
    var phoneNumber: String?
    var gender: GenderEnum?
}
