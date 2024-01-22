import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                loginForm
            }
        }
        .onAppear {
            viewModel.resetMessage()
        }
    }

    private var loginForm: some View {
        VStack {
            CustomTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope", isSecure: false)
                .disabled(viewModel.isLoading)
            CustomTextField(placeholder: "Password", text: $viewModel.password, iconName: "lock", isSecure: true)
                .disabled(viewModel.isLoading)
            MessageView(message: viewModel.successMessage, messageType: .success)
            MessageView(message: viewModel.errorMessage, messageType: .error)

            HStack {
                Spacer()
                Button("Forgot Password?") {
                    viewModel.forgotPassword()
                }
                .foregroundColor(.blue)
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)

            CustomButton(title: "Login", action: viewModel.signIn)
                .disabled(viewModel.isLoading)
            Text("Or").padding(10)
            AuthButton(title: "Sign in with Google", action: viewModel.googleSignIn, iconName: "GoogleLogo")
                .disabled(viewModel.isLoading)
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
