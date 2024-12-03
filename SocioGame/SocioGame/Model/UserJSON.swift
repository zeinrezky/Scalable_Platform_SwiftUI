//
//  UserJSON.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import Foundation

/// Enumeration representing the gender of a user.
///
/// - female: Represents female gender with a raw value of 0.
/// - male: Represents male gender with a raw value of 1.
enum GenderEnum: Int, Codable {
    case female = 0
    case male = 1
}

/// A structure representing a user's data.
///
/// This structure conforms to the `Codable` protocol to enable
/// easy encoding and decoding for use with JSON and other data formats.
struct UserJSON: Codable {

    var uid: String?
    var email: String?
    var phoneNumber: String?
    var gender: GenderEnum?
}
