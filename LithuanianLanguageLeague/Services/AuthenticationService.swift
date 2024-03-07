import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import UIKit

class AuthenticationService: ObservableObject {
    static let shared = AuthenticationService()

    private let firebaseAuthService: FirebaseAuthenticationService
    private let googleAuthService: GoogleAuthenticationService

    init() {
        firebaseAuthService = FirebaseAuthenticationService()
        googleAuthService = GoogleAuthenticationService()
    }

    // Firebase Authentication Methods
    func signUpWithEmail(email: String, password: String,
                         completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        firebaseAuthService.signUp(email: email, password: password, completion: completion)
    }

    func signInWithEmail(email: String, password: String,
                         completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        firebaseAuthService.signIn(email: email, password: password, completion: completion)
    }

    func forgotPassword(email: String, completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        firebaseAuthService.forgotPassword(email: email, completion: completion)
    }

    func signOut(completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        firebaseAuthService.signOut(completion: completion)
    }

    // Google Authentication
    func signInWithGoogle(completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        googleAuthService.signIn(completion: completion)
    }
}
