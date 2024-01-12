import Firebase
import SwiftUI

struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    @EnvironmentObject var userData: UserData

    var body: some View {
        VStack {
            if userLoggedIn {
                HomeView()
            } else {
                LoginSignupView()
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener(authStateChanged)
        }
    }

    // New function to handle the authentication state change
    private func authStateChanged(auth _: Auth, user: User?) {
        DispatchQueue.main.async { // Ensure update is on the main thread
            self.userLoggedIn = (user != nil)
        }
    }
}
