//
//  ContentView.swift
//  SocioGame
//
//  Created by zein rezky chandra on 02/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            UserView(userId: "7inLAHiTAkmJ1k1Nh98n").environmentObject(UserManager.shared)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
