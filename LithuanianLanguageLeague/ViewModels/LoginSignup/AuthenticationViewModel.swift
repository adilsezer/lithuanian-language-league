import Firebase
import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var userLoggedIn = false

    func subscribeToAuthenticationChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.userLoggedIn = (user != nil)
            }
        }
    }
}
