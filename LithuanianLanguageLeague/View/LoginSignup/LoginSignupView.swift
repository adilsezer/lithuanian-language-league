import SwiftUI

struct LoginSignupView: View {
    @State private var selectedAuthType = AuthenticationType.login

    var body: some View {
        NavigationView {
            VStack {
                authenticationTypePicker
                selectedAuthenticationView
                Spacer()
            }
            .navigationBarTitle("Welcome", displayMode: .inline)
            .padding()
        }
    }

    private var authenticationTypePicker: some View {
        Picker("Authentication", selection: $selectedAuthType) {
            Text("Login").tag(AuthenticationType.login)
            Text("Signup").tag(AuthenticationType.signup)
            // Add Picker items for other authentication methods here
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

    @ViewBuilder
    private var selectedAuthenticationView: some View {
        switch selectedAuthType {
        case .login:
            LoginView(viewModel: LoginViewModel())
        case .signup:
            SignupView(viewModel: SignUpViewModel())
            // Cases for other authentication methods can be added here
        }
    }
}
