import FirebaseAuth // Required for User type
import FirebaseCore
import Foundation
import UIKit

// This ViewModel should act as an intermediary between the views and the AuthService.
// It should not directly perform authentication tasks but should call AuthService to do so.

// Responsibilities: Preparing data for the views, handling user inputs, and calling AuthService for authentication.

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var successMessage: String?
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false

    private let authService: AuthenticationService

    init(authService: AuthenticationService = .shared) {
        self.authService = authService
    }

    func signUp() {
        guard InputValidator.isValidEmail(email), InputValidator.isValidPassword(password) else {
            errorMessage = "Invalid email or password"
            return
        }

        authService.signUpWithEmail(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.isAuthenticated = true
                self?.errorMessage = nil
            case .failure(let error):
                self?.isAuthenticated = false
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    func resetMessage() {
        errorMessage = nil
    }
}
