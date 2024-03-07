import FirebaseAuth
import Foundation

class UserData: ObservableObject {
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userId: String = ""
    @Published var authToken: String = ""
    @Published var userLoggedIn: Bool = false

    // User preferences
    @Published var notificationsEnabled: Bool = true

    // User roles and permissions
    @Published var userRole: UserRole = .regular

    // Expanded user profile information
    @Published var fullName: String = ""
    @Published var profileImageUrl: URL?

    // Adjusted to use AuthenticationError
    @Published var authenticationState: AuthenticationState = .idle

    init() {
        subscribeToAuthenticationChanges()
    }

    private func subscribeToAuthenticationChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                guard let self else { return }
                if let user {
                    self.updateUser(withFirebaseUser: user)
                } else {
                    self.clearUserData()
                }
            }
        }
    }

    func clearUserData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            userName = ""
            userEmail = ""
            userId = ""
            authToken = ""
            userLoggedIn = false
            notificationsEnabled = true
            userRole = .regular
            fullName = ""
            profileImageUrl = nil
            authenticationState = .idle
        }
    }

    func updateUser(withFirebaseUser firebaseUser: User?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            userLoggedIn = true
            userEmail = firebaseUser?.email ?? "No Email"
            userName = firebaseUser?.displayName ?? userEmail
            userId = firebaseUser?.uid ?? ""
            authToken = firebaseUser?.refreshToken ?? ""
            // Optionally update profile picture URL, roles, etc.
            authenticationState = .success
        }
    }
}
