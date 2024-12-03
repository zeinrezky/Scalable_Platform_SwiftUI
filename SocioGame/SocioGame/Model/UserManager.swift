//
//  UserManager.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import SwiftUI
import Combine

/// A singleton class responsible for managing user data and profile image URL.
/// This class uses the `ObservableObject` protocol to provide reactive updates
/// to the SwiftUI views when the user data or profile image URL changes.
class UserManager: ObservableObject {

    /// The shared singleton instance of `UserManager`.
    static let shared = UserManager()

    /// The current user data, represented as a `UserJSON` object.
    /// Published to notify SwiftUI views when the user data changes.
    @Published var user: UserJSON?

    /// The URL of the user's profile image.
    /// Published to notify SwiftUI views when the profile image URL changes.
    @Published var profileImageURL: URL?
}
