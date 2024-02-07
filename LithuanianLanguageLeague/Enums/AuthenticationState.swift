import FirebaseAuth
import Foundation

enum AuthenticationState {
    case idle
    case loading
    case success
    case error(AuthenticationError)
}
