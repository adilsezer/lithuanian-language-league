import Firebase
import FirebaseAuth

class FirebaseAuthenticationService {
    // MARK: - Firebase Auth Methods

    func signUp(email: String, password: String, completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                completion(.failure(.customError(error.localizedDescription)))
            } else if let user = authResult?.user {
                completion(.success(user))
            } else {
                completion(.failure(.unknownFirebaseSignInError))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                completion(.failure(.customError(error.localizedDescription)))
            } else if let user = authResult?.user {
                completion(.success(user))
            } else {
                completion(.failure(.unknownFirebaseSignInError))
            }
        }
    }

    func forgotPassword(email: String, completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(.failure(.customError(error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }

    func signOut(completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(.customError(error.localizedDescription)))
        }
    }
}
