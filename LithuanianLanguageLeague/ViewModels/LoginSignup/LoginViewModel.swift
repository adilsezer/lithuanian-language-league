import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoading = false
    var authService: AuthenticationService = .shared

    func signIn() {
        guard validateCredentials() else { return }

        isLoading = true
        authService.signInWithEmail(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.handleAuthenticationResult(result)
            }
        }
    }

    func googleSignIn() {
        // Implement Google sign-in logic here
        authService.signInWithGoogle() // Adjust according to your service's method signature
    }

    func forgotPassword() {
        guard InputValidator.isValidEmail(email) else {
            errorMessage = "Invalid email"
            return
        }
        authService.forgotPassword(email: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.successMessage = "Password reset link sent."
                    self?.errorMessage = nil
                case let .failure(error):
                    self?.errorMessage = error.localizedDescription
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

    private func handleAuthenticationResult(_ result: Result<User, Error>) {
        switch result {
        case .success:
            successMessage = "Sign-in successful"
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
