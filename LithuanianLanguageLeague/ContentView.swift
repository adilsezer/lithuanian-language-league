import Firebase
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewViewModel // Assume initialised correctly

    var body: some View {
        VStack {
            if viewModel.shouldShowDashboard {
                DashboardView() // Assuming DashboardView is correctly handling UserData
            } else {
                LoginSignupView(viewModel: LoginSignupViewModel())
            }
        }
    }
}

#Preview {
    ContentView(viewModel: ContentViewViewModel(userData: UserData()))
}
