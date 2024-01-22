import Firebase
import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var userLoggedIn = false

    func subscribeToAuthenticationChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                // Using a boolean test to check if user is not nil
                self?.userLoggedIn = user != nil
            }
        }
    }
}
