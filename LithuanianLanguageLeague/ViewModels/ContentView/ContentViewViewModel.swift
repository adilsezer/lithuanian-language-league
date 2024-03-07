import Foundation

class ContentViewViewModel: ObservableObject {
    @Published var shouldShowDashboard: Bool = false
    private var userData: UserData

    init(userData: UserData) {
        self.userData = userData
        // Directly observe changes to userLoggedIn
        observeUserLoginStatus()
    }

    private func observeUserLoginStatus() {
        // Observe changes to userLoggedIn and update shouldShowDashboard
        shouldShowDashboard = userData.userLoggedIn
    }
}
