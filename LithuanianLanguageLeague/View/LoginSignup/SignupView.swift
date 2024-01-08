import SwiftUI

struct SignupView: View {
    @ObservedObject var viewModel: LoginSignupViewModel

    var body: some View {
        VStack {
            MessageView(message: viewModel.successMessage, messageType: .success)
            MessageView(message: viewModel.errorMessage, messageType: .error)

            CustomTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope")
            CustomTextField(placeholder: "Password", text: $viewModel.password, iconName: "lock", isSecure: true)
            CustomButton(title: "Signup", action: viewModel.signUp)
        }
    }
}

#Preview {
    SignupView(viewModel: LoginSignupViewModel())
}
