import SwiftUI

struct LoginSignupView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var signUpViewModel = SignUpViewModel()
    @State private var isShowingLogin = true // Toggle between Login and Signup

    var body: some View {
        NavigationView {
            VStack {
                optionsPicker
                if isShowingLogin {
                    LoginView(viewModel: loginViewModel)
                } else {
                    SignupView(viewModel: signUpViewModel)
                }
                Spacer()
            }
            .navigationBarTitle("Welcome", displayMode: .inline)
            .padding()
        }
    }

    private var optionsPicker: some View {
        Picker("Options", selection: $isShowingLogin) {
            Text("Login").tag(true)
            Text("Signup").tag(false)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}
