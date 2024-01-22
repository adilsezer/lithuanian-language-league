import Firebase
import SwiftUI

struct HomeView: View {
    // HomeView: The logout functionality is directly calling Auth.auth().signOut().
    // This could be moved to the ViewModel for a cleaner separation of concerns.
    var body: some View {
        VStack {
            Text("Welcome, \(Auth.auth().currentUser?.displayName ?? "User")")
            Button("Log Out", action: {
                try? Auth.auth().signOut()
            })
        }
    }
}
