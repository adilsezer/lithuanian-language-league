import Firebase
import Foundation
import GoogleSignIn
import GoogleSignInSwift

class Authentication {
    enum SignInState {
        case signedIn
        case signedOut
    }

    @Published var signInState: SignInState = .signedOut
    @Published var email: String?
    @Published var userProfilePhotoURL: String?
    @Published var userIdToken: String?

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
            print("Found previous Sign In. User: \(user?.userID ?? ""). Authenticating...")
            self?.authenticateUser(for: user, with: error)
        }
    }

    private func startNewSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        print("Client ID: \(clientID)")
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration

        DispatchQueue.main.async {
            self.presentSignInUI()
        }
    }

    private func presentSignInUI() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }
        print("Signing in new user")
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            guard let signInResult = signInResult else {
                print("Error during Google Sign In: \(String(describing: error))")
                return
            }
            self?.authenticateUser(for: signInResult.user, with: error)
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            signInState = .signedOut
        } catch {
            print(error.localizedDescription)
        }
    }

    func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print("There is an error signing the user in ==> \(error)")
            return
        }
        guard let user = user, let idToken = user.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if error != nil {
                print(error as Any)
            } else {
                self?.email = authResult?.user.email
                self?.userIdToken = authResult?.additionalUserInfo?.username
                self?.signInState = .signedIn
            }
        }
    }
}
