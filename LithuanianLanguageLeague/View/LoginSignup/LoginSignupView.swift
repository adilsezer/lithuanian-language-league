import SwiftUI

struct LoginSignupView: View {
    @StateObject var viewModel = LoginSignupViewModel()
    @State private var isShowingLogin = true // Toggle between Login and Signup

    var body: some View {
        NavigationView {
            VStack {
                optionsPicker
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

    private var optionsPicker: some View {
        Picker("Options", selection: $isShowingLogin) {
            Text("Login").tag(true)
            Text("Signup").tag(false)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .onChange(of: isShowingLogin) {
            viewModel.resetMessage()
        }
    }
}
