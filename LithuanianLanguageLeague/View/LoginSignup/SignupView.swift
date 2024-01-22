import SwiftUI

struct SignupView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        VStack {
            CustomTextField(placeholder: "Email", text: $viewModel.email, iconName: "envelope", isSecure: false)
            CustomTextField(placeholder: "Password", text: $viewModel.password, iconName: "lock", isSecure: true)
            MessageView(message: viewModel.successMessage, messageType: .success)
            MessageView(message: viewModel.errorMessage, messageType: .error)
            CustomButton(title: "Signup", action: viewModel.signUp)
        }
    }
}

#Preview {
    SignupView(viewModel: SignUpViewModel())
}
