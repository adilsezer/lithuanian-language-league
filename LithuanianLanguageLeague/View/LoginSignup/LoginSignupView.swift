import SwiftUI

struct LoginSignupView: View {
    @StateObject var viewModel = LoginSignupViewModel()
    @State private var isShowingLogin = true // Toggle between Login and Signup

    var body: some View {
        NavigationView {
            VStack {
                Picker("Options", selection: $isShowingLogin) {
                    Text("Login").tag(true)
                    Text("Signup").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: self.isShowingLogin) {
                    viewModel.resetMessage()
                }

                if isShowingLogin {
                    LoginView(viewModel: viewModel)
                } else {
                    SignupView(viewModel: viewModel)
                }

                Spacer()
            }
            .navigationBarTitle("Welcome", displayMode: .inline)
            .padding()
        }
    }
}

// Assuming LoginSignupViewModel and other Views are defined elsewhere
