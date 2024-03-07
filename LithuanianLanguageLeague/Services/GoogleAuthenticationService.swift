import Firebase
import GoogleSignIn
import UIKit

class GoogleAuthenticationService {
    // Initiates the Google sign-in process.
    func signIn(completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            restorePreviousSignIn(completion: completion)
        } else {
            presentSignInUI(completion: completion)
        }
    }

    // Attempts to restore a previous sign-in session.
    private func restorePreviousSignIn(completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let error {
                completion(.failure(.customError(error.localizedDescription)))
            } else if let user {
                self?.authenticateUser(for: user, completion: completion)
            } else {
                completion(.failure(.unknownSignInRestorationError))
            }
        }
    }

    // Presents the Google sign-in UI to the user.
    private func presentSignInUI(completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else {
            completion(.failure(.failedToGetRootViewController))
            return
        }

        let clientID = FirebaseApp.app()?.options.clientID ?? ""
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            if let error {
                completion(.failure(.customError(error.localizedDescription)))
            } else if let user = signInResult?.user {
                self?.authenticateUser(for: user, completion: completion)
            } else {
                completion(.failure(.unknownSignInError))
            }
        }
    }

    // Authenticates the user with Firebase using the Google sign-in credentials.
    private func authenticateUser(
        for user: GIDGoogleUser,
        completion: @escaping (Result<User, AuthenticationError>) -> Void
    ) {
        guard let idToken = user.idToken?.tokenString else {
            completion(.failure(.failedToGetIDToken))
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error {
                completion(.failure(.customError(error.localizedDescription)))
            } else if let firebaseUser = authResult?.user {
                completion(.success(firebaseUser))
            } else {
                completion(.failure(.unknownFirebaseSignInError))
            }
        }
    }
}
