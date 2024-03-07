import SwiftUI

struct AuthButton: View {
    var title: String
    var action: () -> Void
    var iconName: String? // Optional SF Symbol name

    var body: some View {
        Button(action: action) {
            HStack {
                if let iconName {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                Text(title)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 15)
    }
}
