import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var successMessage: String?
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false

    private let authService: AuthenticationService

    init(authService: AuthenticationService = .shared) {
        self.authService = authService
    }

    func signIn() {
        guard InputValidator.isValidEmail(email), InputValidator.isValidPassword(password) else {
            errorMessage = "Invalid email or password"
            return
        }

        authService.signInWithEmail(email: email, password: password) { [weak self] result in
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
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    func resetMessage() {
        errorMessage = nil
    }
}
