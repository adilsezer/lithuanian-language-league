import Firebase
import SwiftUI

struct ContentView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)

    var body: some View {
        VStack {
            if userLoggedIn {
                HomeView()
            } else {
                LoginSignupView()
            }
        }.onAppear {
            Auth.auth().addStateDidChangeListener { _, user in
                DispatchQueue.main.async { // Ensure update is on the main thread
                    self.userLoggedIn = (user != nil)
                }
            }
        }
    }
}
