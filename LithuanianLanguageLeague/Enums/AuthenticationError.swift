import Foundation

// Define a general AuthenticationError enum for use in both services
enum AuthenticationError: Error {
    case unknownSignInRestorationError
    case failedToGetRootViewController
    case unknownSignInError
    case failedToGetIDToken
    case unknownFirebaseSignInError
    case customError(String) // Allows for other error messages

    var localizedDescription: String {
        switch self {
        case .unknownSignInRestorationError:
            "Unknown error occurred during sign-in restoration."
        case .failedToGetRootViewController:
            "Failed to get root view controller."
        case .unknownSignInError:
            "Unknown error occurred during sign-in."
        case .failedToGetIDToken:
            "Failed to get ID token from user."
        case .unknownFirebaseSignInError:
            "Unknown error occurred during Firebase sign-in."
        case let .customError(message):
            message
        }
    }
}
