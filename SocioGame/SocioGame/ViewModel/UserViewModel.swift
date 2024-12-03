//
//  UserViewModel.swift
//  SocioGame
//
//  Created by zein rezky chandra on 03/12/24.
//

import Foundation
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var user: UserJSON?

    private let db = Firestore.firestore()

    func fetchUser(uid: String) {
        db.collection("USERS").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: UserJSON.self)
                    DispatchQueue.main.async {
                        self.user = user
                    }
                } catch {
                    print("Error decoding user: \(error)")
                }
            } else {
                print("User does not exist")
            }
        }
    }
}
