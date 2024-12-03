//
//  UserView.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        VStack {
            if let user = viewModel.user {
                Text("UID: \(user.uid ?? "N/A")")
                Text("Email: \(user.email ?? "N/A")")
                Text("Phone Number: \(user.phoneNumber ?? "N/A")")
                Text("Gender: \(user.gender == .male ? "Male" : "Female")")
            } else {
                Text("Loading user data...")
            }
        }
        .onAppear {
            viewModel.fetchUser(uid: "7inLAHiTAkmJ1k1Nh98n")
        }
    }
}

#Preview {
    UserView()
}
