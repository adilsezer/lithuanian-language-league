import Firebase
import SwiftUI

struct DashboardView: View {
    @ObservedObject private var viewModel = DashboardViewModel()

    var body: some View {
        VStack {
            Text("Welcome, \(Auth.auth().currentUser?.displayName ?? "User")")
            Button("Log Out") {
                viewModel.logOut()
            }
        }
    }
}
