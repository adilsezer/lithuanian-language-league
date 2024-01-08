import FirebaseAuth // Required for User type
import FirebaseCore
import Foundation
import UIKit

class LoginSignupViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var operationSuccess = false
    @Published var isAuthenticated = false

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    private func handleOperationCompletion(
        withSuccess success: Bool,
        successMessage: String? = nil,
        error: Error? = nil
    ) {
        DispatchQueue.main.async { // Ensure UI updates on the main thread
            if success {
                self.errorMessage = nil
                self.successMessage = successMessage
                self.operationSuccess = true
            } else {
                self.handleLoginError(error)
            }
        }
    }

    private func handleLoginError(_ error: Error?) {
        DispatchQueue.main.async { // Ensure updates on the main thread
            self.operationSuccess = false
            self.successMessage = nil // Clear success message in case of error

            if let loginError = error as? LoginError {
                self.errorMessage = loginError.localizedDescription
            } else if let nsError = error as NSError?, nsError.domain == NSURLErrorDomain {
                self.errorMessage = LoginError.networkError.localizedDescription
            } else {
                self.errorMessage = LoginError.unknownError.localizedDescription
            }
        }
    }

    func resetMessage() {
        successMessage = nil
        errorMessage = nil
    }

    func googleSignIn() {
        Task {
            do {
                try await Authentication().signInWithGoogle()
                DispatchQueue.main.async {
                    self.operationSuccess = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleLoginError(error)
                }
            }
        }
    }

    func signIn() {
        guard isValidEmail(email), isValidPassword(password) else {
            errorMessage = LoginError.invalidCredentials.localizedDescription
            return
        }

        AuthService.shared.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.handleOperationCompletion(withSuccess: true, error: nil)
            case .failure(let error):
                self?.handleOperationCompletion(withSuccess: false, error: error)
            }
        }
    }

    func signUp() {
        guard isValidEmail(email) else {
            errorMessage = LoginError.emptyEmail.localizedDescription
            return
        }
        guard isValidPassword(password) else {
            errorMessage = LoginError.weakPassword.localizedDescription
            return
        }

        AuthService.shared.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.handleOperationCompletion(withSuccess: true, successMessage: "Signup successful.")
            case .failure(let error):
                self?.handleOperationCompletion(withSuccess: false, error: error)
            }
        }
    }

    func forgotPassword() {
        guard !email.isEmpty else {
            errorMessage = LoginError.emptyEmail.localizedDescription
            return
        }

        AuthService.shared.forgotPassword(email: email) { [weak self] result in
            switch result {
            case .success:
                self?.handleOperationCompletion(
                    withSuccess: true,
                    successMessage: "A password reset link has been sent to your email."
                )
            case .failure(let error):
                self?.handleOperationCompletion(withSuccess: false, error: error)
            }
        }
    }
}
