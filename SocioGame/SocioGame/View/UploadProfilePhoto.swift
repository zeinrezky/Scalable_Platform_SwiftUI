//
//  UploadProfilePhoto.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import SwiftUI

struct UploadProfilePhoto: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var uploadStatus: String = ""
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        VStack(spacing: 20) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
            }

            Button("Select Photo") {
                showImagePicker = true
            }

            Button("Upload Photo") {
                guard let image = selectedImage else {
                    uploadStatus = "No image selected!"
                    return
                }

                uploadStatus = "Uploading..."
                if let userId = getCurrentUserId() {
                    uploadProfileImageWithBackgroundSupport(image, userId: userId) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let url):
                                print("Upload successful! File URL: \(url)")
                            case .failure(let error):
                                print("Upload failed: \(error.localizedDescription)")
                            }
                        }
                    }
                }

            }

            Text(uploadStatus)
                .foregroundColor(.gray)
                .font(.footnote)
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}
