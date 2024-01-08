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
//    @Published var user :GIDGoogleUser? = nil
    @Published var userIdToken: String?

    func signInWithGoogle() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
                if error != nil {
                    print("Error with Previous Sign in Discovery.")
                    return
                }
                print("Found previous Sign In. User: \(user?.userID ?? ""). Authenticating2... ")
                authenticateUser(for: user, with: error)
            }
        } else {
            // 2
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            print("does client ID work?" + clientID)
            // 3
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            // 4
            DispatchQueue.main.async { // Ensure UI operations are on the main thread
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

                // 5
                print("signing in new user")
                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                    guard let signInResult = signInResult else {
                        print("Error! \(String(describing: error))")
                        return
                    }
                    self.authenticateUser(for: signInResult.user, with: error)
                }
            }
        }
    }

    func signOut() {
        // 1
        GIDSignIn.sharedInstance.signOut()

        do {
            // 2
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

        Auth.auth().signIn(with: credential) { authResult, error in
            if error != nil {
                print(error as Any)
            } else {
//                self.userProfilePhotoURL = authResult?.user.photoURL
//                self.userId = authResult?.user.uid
                self.email = authResult?.user.email
                self.userIdToken = authResult?.additionalUserInfo?.username
                self.signInState = .signedIn
            }
        }
    }
}
