import FirebaseAuth
import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var successMessage: String?

    var authService: AuthenticationService = .shared
    var userData: UserData

    init(userData: UserData) {
        self.userData = userData
    }

    func signUp() {
        guard InputValidator.isValidEmail(email), InputValidator.isValidPassword(password) else {
            errorMessage = "Invalid email or password"
            return
        }

        isLoading = true
        userData.authenticationState = .loading
        authService.signUpWithEmail(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case let .success(user):
                    self?.userData.updateUser(withFirebaseUser: user)
                    self?.userData.authenticationState = .success
                    self?.errorMessage = nil
                    self?.successMessage = "Signup successful"
                case let .failure(error):
                    self?.userData.authenticationState = .failed(error)
                    self?.errorMessage = self?.processError(error)
                }
            }
        }
    }

    private func processError(_ error: AuthenticationError) -> String {
        if case let .customError(message) = error {
            message
        } else {
            error.localizedDescription
        }
    }
}
