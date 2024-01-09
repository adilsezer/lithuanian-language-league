import FirebaseAuth
import FirebaseCore
import Foundation
import SwiftUI

class AuthService {
    static let shared = AuthService()

    @Published var currentUser: User?

    // Private initialiser to prevent instantiation from outside
    // This is a common practice in implementing the singleton pattern.
    // The singleton pattern ensures that only one instance of AuthService exists
    // throughout the application, providing a global point of access to it.
    private init() {}

    func listenForAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func getUserInfo() -> User? {
        return Auth.auth().currentUser
    }
}
