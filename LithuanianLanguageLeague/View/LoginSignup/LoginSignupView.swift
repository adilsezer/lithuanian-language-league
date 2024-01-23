import SwiftUI

struct LoginSignupView: View {
    @ObservedObject var viewModel: LoginSignupViewModel

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
        Picker("Authentication", selection: $viewModel.selectedAuthType) {
            Text("Login").tag(AuthenticationType.login)
            Text("Signup").tag(AuthenticationType.signup)
            // Add Picker items for other authentication methods here
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

    @ViewBuilder
    private var selectedAuthenticationView: some View {
        switch viewModel.selectedAuthType {
        case .login:
            LoginView(viewModel: viewModel.loginViewModel)
        case .signup:
            SignupView(viewModel: viewModel.signUpViewModel)
            // Cases for other authentication methods can be added here
        }
    }
}
