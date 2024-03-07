import FirebaseAuth
import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoading = false

    var authService: AuthenticationService = .shared
    var userData: UserData

    init(userData: UserData) {
        self.userData = userData
    }

    func signIn() {
        guard validateCredentials() else { return }

        isLoading = true
        userData.authenticationState = .loading
        authService.signInWithEmail(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(user):
                    self?.userData.updateUser(withFirebaseUser: user)
                    self?.userData.authenticationState = .success
                    self?.successMessage = "Successfully signed in"
                    self?.errorMessage = nil
                case let .failure(error):
                    self?.userData.authenticationState = .failed(error)
                    self?.errorMessage = self?.processError(error)
                    self?.successMessage = nil
                }
            }
        }
    }

    func googleSignIn() {
        isLoading = true
        userData.authenticationState = .loading
        authService.signInWithGoogle { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(user):
                    self?.userData.updateUser(withFirebaseUser: user)
                    self?.userData.authenticationState = .success
                    self?.successMessage = "Successfully signed in with Google"
                    self?.errorMessage = nil
                case let .failure(error):
                    self?.userData.authenticationState = .failed(error)
                    self?.errorMessage = self?.processError(error)
                    self?.successMessage = nil
                }
            }
        }
    }

    func forgotPassword() {
        guard InputValidator.isValidEmail(email) else {
            errorMessage = "Invalid email"
            return
        }
        isLoading = true
        authService.forgotPassword(email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.successMessage = "Password reset link sent."
                    self?.errorMessage = nil
                case let .failure(error):
                    self?.errorMessage = self?.processError(error)
                    self?.successMessage = nil
                }
            }
        }
    }

    private func validateCredentials() -> Bool {
        guard InputValidator.isValidEmail(email), InputValidator.isValidPassword(password) else {
            errorMessage = "Invalid email or password"
            return false
        }
        return true
    }

    func resetMessage() {
        errorMessage = nil
        successMessage = nil
    }

    private func processError(_ error: AuthenticationError) -> String {
        if case let .customError(message) = error {
            message
        } else {
            error.localizedDescription
        }
    }
}
