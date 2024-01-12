import Foundation

enum LoginError: Error, LocalizedError {
    case invalidCredentials
    case networkError
    case unknownError
    case emptyEmail
    case weakPassword
    case generalError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            "Invalid email or password. Please try again."
        case .networkError:
            "Network error. Please check your internet connection."
        case .unknownError:
            "An unknown error occurred. Please try again later."
        case .emptyEmail:
            "Email field is empty. Please enter your email."
        case .weakPassword:
            "Password is too weak. Please use a stronger password."
        case let .generalError(error):
            // Here you can handle general errors
            // For example, if you want to handle NSError with a specific domain
            if let nsError = error as NSError?, nsError.domain == NSURLErrorDomain {
                "Network error. Please check your internet connection."
            } else {
                error.localizedDescription
            }
        }
    }

    // Method to create a LoginError from any Error
    static func parseError(_ error: Error) -> LoginError {
        // Here, you can add more specific error handling if needed
        .generalError(error)
    }
}
