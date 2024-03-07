import FirebaseAuth
import Foundation

// Adjusted to specifically use AuthenticationError
enum AuthenticationState {
    case idle
    case loading
    case success
    case failed(AuthenticationError)
}
