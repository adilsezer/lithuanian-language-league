import FirebaseAuth
import Foundation

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoading = false
    var authService: AuthenticationService = .shared

    func signUp() {
        guard validateCredentials() else { return }

        isLoading = true
        authService.signUpWithEmail(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.handleAuthenticationResult(result)
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

    private func handleAuthenticationResult(_ result: Result<User, Error>) {
        switch result {
        case .success:
            successMessage = "Signup successful"
            errorMessage = nil
        case let .failure(error):
            errorMessage = error.localizedDescription
            successMessage = nil
        }
    }

    func resetMessage() {
        errorMessage = nil
        successMessage = nil
    }
}
