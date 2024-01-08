import Firebase
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome, \(Auth.auth().currentUser?.displayName ?? "User")")
            Button("Log Out", action: {
                try? Auth.auth().signOut()
            })
        }
    }
}
