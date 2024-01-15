import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import UIKit

class AuthenticationService: ObservableObject {
    static let shared = AuthenticationService()

    private let firebaseAuthService = FirebaseAuthenticationService()
    private let googleAuthService = GoogleAuthenticationService()

    @Published var currentUser: User?
    @Published var signInState: FirebaseAuthenticationService.SignInState = .signedOut

    init() {
        observeFirebaseAuthState()
    }

    private func observeFirebaseAuthState() {
        // Synchronize the AuthenticationService state with the FirebaseAuthenticationService
        firebaseAuthService.$currentUser
            .assign(to: &$currentUser)
        firebaseAuthService.$signInState
            .assign(to: &$signInState)
    }

    // MARK: - Firebase Authentication Methods

    func signUpWithEmail(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuthService.signUp(email: email, password: password, completion: completion)
    }

    func signInWithEmail(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        firebaseAuthService.signIn(email: email, password: password, completion: completion)
    }

    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        firebaseAuthService.forgotPassword(email: email, completion: completion)
    }

    // MARK: - Google Authentication

    func signInWithGoogle() {
        googleAuthService.signIn { [weak self] result in
            switch result {
            case let .success(user):
                self?.currentUser = user
                self?.signInState = .signedIn
            case let .failure(error):
                print("Error signing in with Google: \(error.localizedDescription)")
                self?.signInState = .signedOut
            }
        }
    }

    func signOut() {
        firebaseAuthService.signOut()
        // Assuming Google Sign-Out is handled within Firebase Sign-Out in FirebaseAuthenticationService
    }
}
