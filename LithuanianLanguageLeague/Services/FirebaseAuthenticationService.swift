import Firebase
import FirebaseAuth

class FirebaseAuthenticationService: ObservableObject {
    @Published var currentUser: User?
    @Published var signInState: SignInState = .signedOut

    enum SignInState {
        case signedIn
        case signedOut
    }

    init() {
        listenForAuthChanges()
    }

    // MARK: - Firebase Auth Listeners

    private func listenForAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.signInState = user != nil ? .signedIn : .signedOut
            }
        }
    }

    // MARK: - Firebase Auth Methods

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            signInState = .signedOut
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
