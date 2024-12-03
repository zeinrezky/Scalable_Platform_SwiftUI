//
//  UserView.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()

    var userId: String

    var body: some View {
        VStack {
            if let profileImageURL = viewModel.profileImageURL {
                AsyncImage(url: profileImageURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                .clipShape(Circle())
            }

            if let user = viewModel.user {
                Text("UID: \(user.uid ?? "N/A")")
                Text("Email: \(user.email ?? "N/A")")
                Text("Phone: \(user.phoneNumber ?? "N/A")")
                Text("Gender: \(user.gender?.rawValue == 1 ? "male" : "female")")
            }
        }
        .onAppear {
            viewModel.fetchUserData(userId: userId)
            viewModel.fetchProfileImage(userId: userId)
        }
    }
}

#Preview {
    UserView(userId: "")
}
