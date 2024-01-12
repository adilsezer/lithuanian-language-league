import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import UIKit

class GoogleAuthenticationService {
    private var signInCompletion: ((Result<User, Error>) -> Void)?

    func signIn(completion: @escaping (Result<User, Error>) -> Void) {
        signInCompletion = completion

        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            restorePreviousSignIn()
        } else {
            presentSignInUI()
        }
    }

    private func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let error {
                self?.signInCompletion?(.failure(error))
            } else {
                self?.authenticateUser(for: user)
            }
        }
    }

    private func presentSignInUI() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }

        let clientID = FirebaseApp.app()?.options.clientID ?? ""
        let configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = configuration

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            if let error {
                self?.signInCompletion?(.failure(error))
            } else {
                self?.authenticateUser(for: signInResult?.user)
            }
        }
    }

    private func authenticateUser(for user: GIDGoogleUser?) {
        guard let user, let idToken = user.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error {
                self?.signInCompletion?(.failure(error))
            } else if let user = authResult?.user {
                self?.signInCompletion?(.success(user))
            }
        }
    }
}
