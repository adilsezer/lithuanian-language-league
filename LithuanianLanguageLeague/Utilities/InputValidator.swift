import Foundation

enum InputValidator {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        // Define your password criteria here.
        // For example, a minimum length of 6 characters.
        password.count >= 6
    }
}
