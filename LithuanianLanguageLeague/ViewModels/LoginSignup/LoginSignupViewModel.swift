import Combine
import Foundation

class LoginSignupViewModel: ObservableObject {
    @Published var selectedAuthType: AuthenticationType = .login

    var loginViewModel: LoginViewModel
    var signUpViewModel: SignUpViewModel

    init(loginViewModel: LoginViewModel = LoginViewModel(),
         signUpViewModel: SignUpViewModel = SignUpViewModel()) {
        self.loginViewModel = loginViewModel
        self.signUpViewModel = signUpViewModel
    }

    // Additional methods and logic can be added here if necessary
}
