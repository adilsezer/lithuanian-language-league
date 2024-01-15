import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            CustomTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope")
            CustomTextField(placeholder: "Password", text: $viewModel.password, iconName: "lock", isSecure: true)
            MessageView(message: viewModel.successMessage, messageType: .success)
            MessageView(message: viewModel.errorMessage, messageType: .error)

            HStack {
                Spacer()
                Button("Forgot Password?") {
                    viewModel.forgotPassword()
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)

            CustomButton(title: "Login", action: viewModel.signIn)
            Text("Or").padding(10)
            AuthButtton(title: "Sign in with Google", action: viewModel.googleSignIn, iconName: "GoogleLogo")
        }
        .onAppear {
            viewModel.resetMessage()
        }
    }
}

// Preview
#if DEBUG
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView(viewModel: LoginViewModel())
        }
    }
#endif

#Preview {
    LoginView(viewModel: LoginViewModel())
}
