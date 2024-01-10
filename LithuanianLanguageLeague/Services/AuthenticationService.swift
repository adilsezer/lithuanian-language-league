import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

class AuthenticationService: ObservableObject {
    static let shared = AuthenticationService()

    @Published var currentUser: User?
    @Published var signInState: SignInState = .signedOut

    private init() {
        listenForAuthChanges()
    }

    enum SignInState {
        case signedIn
        case signedOut
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

    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            signInState = .signedOut
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    // MARK: - Google Sign-In Methods
    func signInWithGoogle() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            restorePreviousSignIn()
        } else {
            startNewSignIn()
        }
    }

    private func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let error = error {
                print("Error with Previous Sign in Discovery: \(error).")
                return
            }
            self?.authenticateUser(for: user, with: error)
        }
    }

    private func startNewSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration

        DispatchQueue.main.async {
            self.presentSignInUI()
        }
    }

    private func presentSignInUI() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            guard let signInResult = signInResult else {
                print("Error during Google Sign In: \(String(describing: error))")
                return
            }
            self?.authenticateUser(for: signInResult.user, with: error)
        }
    }

    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print("There is an error signing the user in ==> \(error)")
            return
        }
        guard let user = user, let idToken = user.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                print("Error in Firebase Sign In: \(error.localizedDescription)")
            } else {
                self?.currentUser = authResult?.user
                self?.signInState = .signedIn
            }
        }
    }
}
