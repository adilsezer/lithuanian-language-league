import Combine
class ContentViewViewModel: ObservableObject {
    @Published var shouldShowDashboard: Bool = false
    private var userData: UserData
    private var cancellables = Set<AnyCancellable>()

    init(userData: UserData) {
        self.userData = userData
        observeUserLoginStatus()
    }

    private func observeUserLoginStatus() {
        // Observe changes to authenticationState and update shouldShowDashboard
        userData.$authenticationState
            .map { state in
                switch state {
                case .success:
                    true
                default:
                    false
                }
            }
            .assign(to: \.shouldShowDashboard, on: self)
            .store(in: &cancellables)
    }
}
