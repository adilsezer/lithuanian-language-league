import Firebase
import SwiftUI

struct DashboardView: View {
    @ObservedObject private var viewModel = DashboardViewModel()
    @EnvironmentObject var userData: UserData // Assuming UserData is provided as an environment object

    var body: some View {
        VStack {
            Text("Welcome, \(userData.userName)")
            // Use more user data as needed
            Button("Log Out") {
                viewModel.logOut()
            }
        }
    }
}
