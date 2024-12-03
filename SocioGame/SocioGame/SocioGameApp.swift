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
        #if DEVELOPMENT
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
        #elseif STAGING
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Staging", ofType: "plist")
        #else
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        #endif

        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!) else {
            fatalError("Couldn't load Firebase config file")
        }
        FirebaseApp.configure(options: fileopts)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
