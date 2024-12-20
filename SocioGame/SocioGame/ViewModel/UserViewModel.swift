//
//  UserViewModel.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit
import Combine

/// ViewModel for managing user-related data and interactions with Firebase.
class UserViewModel: ObservableObject {
    
    @Published var users: [UserJSON] = []
    @Published var user: UserJSON?
    @Published var profileImageURL: URL?

    private var userManager = UserManager.shared
    private let db = Firestore.firestore()

    /// Fetches user data from Firestore based on the user ID.
    ///
    /// - Parameter userId: The unique identifier for the user.
    func fetchUserData(userId: String) {
        let db = Firestore.firestore()
        db.collection("USERS").document(userId).getDocument { [self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }

            userManager.user = UserJSON(
                uid: data["uid"] as? String,
                name: data["name"] as? String,
                email: data["email"] as? String,
                phoneNumber: data["phoneNumber"] as? String,
                gender: GenderEnum(rawValue: data["gender"] as? Int ?? -1),
                servicePricing: data["servicePricing"] as? Double,
                rating: data["rating"] as? Double,
                ratingCount: data["ratingCount"] as? Int,
                lastActive: data["lastActive"] as? String,
                profileImageBase64: data["profileImageBase64"] as? String
            )
            user = userManager.user
            
            // updating last active
            updateLastActive(userId: userId)
        }
    }
    
    /// Fetch multiple queries from the USERS collection
    func fetchFilteredUsers() {
        
        // Query for females only
        let isFemaleQuery = db.collection("USERS").whereField("gender", isEqualTo: GenderEnum.female.rawValue).order(by: "lastActive", descending: true).order(by: "rating", descending: true).order(by: "servicePricing", descending: false)

        let queries = [isFemaleQuery]
        var results: [[UserJSON]] = []

        let dispatchGroup = DispatchGroup()

        for query in queries {
            dispatchGroup.enter()
            query.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching query: \(error.localizedDescription)")
                } else if let documents = snapshot?.documents {
                    let users = documents.compactMap { doc -> UserJSON? in
                        let data: [String: Any] = doc.data()
                        return UserJSON(
                            uid: data["uid"] as? String,
                            name: data["name"] as? String,
                            email: data["email"] as? String,
                            phoneNumber: data["phoneNumber"] as? String,
                            gender: GenderEnum(rawValue: data["gender"] as? Int ?? -1),
                            servicePricing: data["servicePricing"] as? Double,
                            rating: data["rating"] as? Double,
                            ratingCount: data["ratingCount"] as? Int,
                            lastActive: data["lastActive"] as? String,
                            profileImageBase64: data["profileImageBase64"] as? String
                        )
                    }
                    results.append(users)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.users = results.flatMap { $0 }
        }
    }

    /// Fetches the profile image URL from Firebase Storage for a given user ID.
    ///
    /// - Parameter userId: The unique identifier for the user.
    func fetchProfileImage(userId: String) {
        let storageRef = Storage.storage().reference().child("profileImages/\(userId).jpg")
        storageRef.downloadURL { url, error in
            guard let url = url, error == nil else { return }
            self.profileImageURL = url
        }
    }
}

/// Retrieves the current logged-in user's ID.
///
/// - Returns: The user ID of the currently authenticated user, or `nil` if no user is logged in.
func getCurrentUserId() -> String? {
    return Auth.auth().currentUser?.uid
}

/// Uploads a profile image to Firebase Storage with background support.
/// 
/// - Parameters:
///   - image: The profile image to upload.
///   - userId: The unique identifier for the user.
///   - completion: A closure that is called with the result of the upload, returning either a URL or an error.
func uploadProfileImageWithBackgroundSupport(
    _ image: UIImage,
    userId: String,
    completion: @escaping (Result<URL, Error>) -> Void
) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        completion(.failure(NSError(domain: "Invalid image data", code: 0, userInfo: nil)))
        return
    }
    let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
    let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        storageRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }

    // Observes upload states to enable background upload.
    uploadTask.observe(.resume) { _ in
        print("Upload resumed")
    }
    uploadTask.observe(.progress) { snapshot in
        let percentComplete = 100.0 * Double(snapshot.progress?.completedUnitCount ?? 0)
            / Double(snapshot.progress?.totalUnitCount ?? 1)
        print("Upload is \(percentComplete)% complete")
    }
    uploadTask.observe(.success) { _ in
        print("Upload completed successfully")
    }
    uploadTask.observe(.failure) { _ in
        print("Upload failed")
    }
}

/// Update last active datetime of a user  from Firestore based on the user ID.
///
/// - Parameter userId: The unique identifier for the user.
func updateLastActive(userId: String) {
    let db = Firestore.firestore()
    db.collection("USERS").document(userId).updateData([
        "lastActive": dateFormatter.string(from: Date())
    ])
}

/// Update last active datetime of a user  from Firestore based on the user ID.
///
/// - Parameter userId: The unique identifier for the user.
func uploadProfileImage(userId: String, profileImage: UIImage) {
    let db = Firestore.firestore()
    DispatchQueue.main.async {
        db.collection("USERS").document(userId).updateData([
            "profileImageBase64": imageToBase64(image: profileImage) ?? ""
        ])
    }
}

