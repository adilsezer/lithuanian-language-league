import Foundation
enum AuthenticationError: Error, LocalizedError {
    case invalidCredentials
    case customError(description: String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            "Invalid email or password."
        case let .customError(description):
            description
        }
    }
}
