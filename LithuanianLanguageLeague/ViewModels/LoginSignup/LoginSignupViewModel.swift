import Combine
import Foundation

class LoginSignupViewModel: ObservableObject {
    @Published var selectedAuthType: AuthenticationType = .login

    // View models for each authentication type
    var loginViewModel: LoginViewModel
    var signUpViewModel: SignUpViewModel

    init(loginViewModel: LoginViewModel = LoginViewModel(),
         signUpViewModel: SignUpViewModel = SignUpViewModel()) {
        self.loginViewModel = loginViewModel
        self.signUpViewModel = signUpViewModel
    }

    // Add methods to handle business logic here
}
