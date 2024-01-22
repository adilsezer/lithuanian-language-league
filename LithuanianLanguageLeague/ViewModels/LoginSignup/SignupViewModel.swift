import Foundation

class SignUpViewModel: AuthenticationViewModelBase {
    func signUp() {
        guard validateCredentials() else { return }

        authService.signUpWithEmail(email: email, password: password) { [weak self] result in
            self?.handleAuthenticationResult(result)
        }
    }
}
