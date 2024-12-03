//
//  UserView.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Profile Image Section
            ZStack(alignment: .top) {
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(radius: 10)

                // Badge - Available Today
                Text("⚡ Available today!")
                    .font(.caption)
                    .bold()
                    .padding(6)
                    .background(Color.gray.opacity(0.7))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .offset(y: -10)
            }

            // Name, Status, and Social Media
            HStack(spacing: 8) {
                Text("Zynx")
                    .font(.title)
                    .bold()

                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.blue)

                Spacer()

                Image(systemName: "instagram")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.pink)
            }
            .padding(.horizontal)

            // Game Badges
            HStack(spacing: 8) {
                Image("mushroom")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                Image("dice")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                Text("+3")
                    .font(.caption)
                    .bold()
                    .frame(width: 50, height: 50)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .padding(.horizontal)

            // Rating and Hourly Rate
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("4.9")
                        .bold()
                    Text("(61)")
                        .foregroundColor(.gray)
                }

                Spacer()

                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.red)
                    Text("110.00/1Hr")
                        .font(.headline)
                        .bold()
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
