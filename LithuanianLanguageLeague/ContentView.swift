import Firebase
import SwiftUI

struct ContentView: View {
    @ObservedObject private var authViewModel = AuthenticationViewModel()

    var body: some View {
        VStack {
            if authViewModel.userLoggedIn {
                HomeView()
            } else {
                LoginSignupView()
            }
        }
        .onAppear {
            authViewModel.subscribeToAuthenticationChanges()
        }
    }
}
