import Firebase
import GoogleSignIn
import SwiftUI
import UIKit

// Define your custom AppDelegate
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Handle Google Sign-In URL
        return GIDSignIn.sharedInstance.handle(url)
    }
}

// Define your SwiftUI App
@main
struct LithuanianLanguageLeagueApp: App {
    // Use the custom AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
