//
//  SocioGameApp.swift
//  SocioGame
//
//  Created by zein rezky chandra on 02/12/24.
//

import SwiftUI
import Firebase

@main
struct SocioGameApp: App {
    
    /// Initialize the Firebase configuration
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
