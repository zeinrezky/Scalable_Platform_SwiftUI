//
//  ImagePicker.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import SwiftUI
import PhotosUI

/// A SwiftUI wrapper for the PHPickerViewController, allowing users to select an image from their photo library.
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage? // The selected image from the photo picker.

    /// Creates and configures the PHPickerViewController.
    ///
    /// - Parameter context: The context for coordinating with UIKit.
    /// - Returns: A configured PHPickerViewController instance.
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    /// Updates the PHPickerViewController when SwiftUI state changes.
    ///
    /// - Parameters:
    ///   - uiViewController: The PHPickerViewController instance.
    ///   - context: The context for coordinating with UIKit.
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    /// Creates a coordinator to manage PHPickerViewController delegate callbacks.
    ///
    /// - Returns: A Coordinator instance.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// A coordinator class for handling PHPickerViewController delegate methods.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: ImagePicker // A reference to the parent ImagePicker.

        /// Initializes the coordinator with the parent ImagePicker.
        ///
        /// - Parameter parent: The parent ImagePicker instance.
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        /// Handles the selection of an image from the photo picker.
        /// 
        /// - Parameters:
        ///   - picker: The PHPickerViewController instance.
        ///   - results: The selected results from the picker.
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
                if let userId = getCurrentUserId() {
                    uploadProfileImageWithBackgroundSupport(image as? UIImage ?? UIImage(), userId: userId) { result in
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
        }
    }
}
