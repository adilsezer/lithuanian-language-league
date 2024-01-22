import Foundation

class LoginViewModel: AuthenticationViewModelBase {
    func signIn() {
        guard validateCredentials() else { return }

        authService.signInWithEmail(email: email, password: password) { [weak self] result in
            self?.handleAuthenticationResult(result)
        }
    }

    func googleSignIn() {
        authService.signInWithGoogle()
    }

    func forgotPassword() {
        guard InputValidator.isValidEmail(email) else {
            errorMessage = "Invalid email"
            return
        }

        authService.forgotPassword(email: email) { [weak self] result in
            switch result {
            case .success:
                self?.errorMessage = "Password reset link sent."
            case let .failure(error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
