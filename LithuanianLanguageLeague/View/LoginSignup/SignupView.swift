import SwiftUI

struct SignupView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                signupForm
            }
        }
    }

    private var signupForm: some View {
        VStack {
            CustomTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope", isSecure: false)
                .disabled(viewModel.isLoading)
            CustomTextField(placeholder: "Password", text: $viewModel.password, iconName: "lock", isSecure: true)
                .disabled(viewModel.isLoading)
            MessageView(message: viewModel.successMessage, messageType: .success)
            MessageView(message: viewModel.errorMessage, messageType: .error)
            CustomButton(title: "Signup", action: viewModel.signUp)
                .disabled(viewModel.isLoading)
        }
    }
}

#Preview {
    SignupView(viewModel: SignUpViewModel())
}
