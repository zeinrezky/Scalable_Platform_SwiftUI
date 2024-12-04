//
//  UserView.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import SwiftUI
import PhotosUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var isImagePickerPresented = false
    @State private var selectedImageNew: UIImage? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var uploadStatus: String = ""
    @State private var landingPageDismiss = false
   
    var body: some View {
        GeometryReader { geometry in
            
            VStack(spacing: 10) {
                // Name, Status, and Social Media
                if let user = viewModel.user {
                    HStack(spacing: 8) {
                        Spacer()
                        Text("\(user.name ?? "N/A")")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary) // Adapts to Dark Mode
                        
                        Image(systemName: "circle.fill")
                                    .resizable()
                                    .foregroundColor(.green)
                                    .frame(width: 15, height: 15)
                        
                        Spacer()

                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)

                        Image("instagram")
                            .renderingMode(.template) // Render image logo as template so it can use foregroundColor
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Profile Image Section
                    ZStack(alignment: .top) {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .frame(height: geometry.size.height / 1.5)
                                .scaledToFit()
                                .clipShape(Rectangle()).cornerRadius(20)
                                .shadow(radius: 10)
                        } else {
                            Image("profile")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Rectangle()).cornerRadius(20)
                                .shadow(radius: 10)
                        }

                        // Badge - Available Today
                        Text("⚡ Available today!")
                            .font(.title3)
                            .padding()
                            .background(
                                BlurView(style: .systemUltraThinMaterialDark) // Blur effect
                            )
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .offset(y: 20)
                            
                    }
                    .padding(.top, 20)
                    .onTapGesture {
                        isImagePickerPresented = true // Open ImagePicker
                    }

                    // Game Badges
                    HStack {
                        Image("dice")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                .strokeBorder(Color(.white), lineWidth: 2.0)
                            )
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                        
                        Image("mushroom")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                .strokeBorder(Color(.white), lineWidth: 2.0)
                            )
                            .background(Color.black.opacity(0.7))
                            .overlay(content: {
                                Text("+3")
                                    .font(.title2)
                                    .bold()
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Circle()
                                        .strokeBorder(Color(.white), lineWidth: 2.0)
                                    )
                                    .background(Color.black.opacity(0.7))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            })
                            .clipShape(Circle())
                            .offset(x: -40)
                        
                        Spacer()
                    }
                    .offset(y: -50)
                    .padding(.horizontal, 20)
                    
                    // Rating and Hourly Rate
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.yellow)
                        Text("\((user.rating ?? 0).cleanValue)")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary) // Adapts to Dark Mode
                        Text("(\(user.ratingCount ?? 0))")
                            .font(.title)
                            .foregroundColor(.secondary) // Adapts to Dark Mode
                        Spacer()
                    }
                    .padding(.horizontal)

                    HStack {
                        Image(systemName: "flame.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .foregroundColor(.red)
                        Text("\((user.servicePricing ?? 0).cleanValue)/1Hr")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary) // Adapts to Dark Mode
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                } else {
                    Text("SocioGame")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.largeTitle)
                }
            }
            .ignoresSafeArea()
            .background(Color(.systemBackground)) // Adapts to Light or Dark mode
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage) // Open ImagePicker
            }
            .onChange(of: selectedImage) {
                guard selectedImage != selectedImageNew else { return }
                uploadProfileImage(userId: "7inLAHiTAkmJ1k1Nh98n", profileImage: selectedImage!) // Upload new image profile
            }
            .onChange(of: viewModel.user?.profileImageBase64) {
                selectedImageNew = base64ToImage(base64String: viewModel.user?.profileImageBase64 ?? "")
                if let selectedImageNew {
                    selectedImage = selectedImageNew // Update image profile base on fetch profile image data
                }
            }
            .onChange(of: viewModel.users.count) {
                print(viewModel.users) // Print out filtered users based on filtered queries
            }
            .onAppear {
                DispatchQueue.main.async {
                    viewModel.fetchUserData(userId: "7inLAHiTAkmJ1k1Nh98n") // Fetch account data
                    viewModel.fetchFilteredUsers() // Fetch filtered user based on query
                }
            }
        
        }
    }
}

