import Firebase
import GoogleSignIn
import SwiftUI
import UIKit

// Define your custom AppDelegate
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _:
                     [UIApplication.LaunchOptionsKey: Any]?) ->
        Bool {
        // Configure Firebase
        FirebaseApp.configure()
        return true
    }

    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Handle Google Sign-In URL
        GIDSignIn.sharedInstance.handle(url)
    }
}

// Define your SwiftUI App
@main
struct LithuanianLanguageLeagueApp: App {
    var userData = UserData()

    // Use the custom AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
        }
    }
}
