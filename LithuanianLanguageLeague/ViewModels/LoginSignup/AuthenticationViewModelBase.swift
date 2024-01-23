import FirebaseAuth
import Foundation

class AuthenticationViewModelBase: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String? // Add this line
    @Published var isLoading = false
    @Published var selectedAuthType: AuthenticationType = .login // Added this line

    let authService: AuthenticationService

    init(authService: AuthenticationService = .shared) {
        self.authService = authService
    }

    func resetMessage() {
        errorMessage = nil
    }

    func validateCredentials() -> Bool {
        guard InputValidator.isValidEmail(email), InputValidator.isValidPassword(password) else {
            errorMessage = "Invalid email or password"
            return false
        }
        return true
    }

    // Common method to handle the result of authentication attempts
    func handleAuthenticationResult(_ result: Result<User, Error>) {
        switch result {
        case .success:
            successMessage = "Signup successful" // Set success message
            errorMessage = nil
        case let .failure(error):
            errorMessage = error.localizedDescription
            successMessage = nil // Reset success message
        }
    }
}
