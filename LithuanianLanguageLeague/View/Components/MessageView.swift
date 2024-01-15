import SwiftUI

struct MessageView: View {
    var message: String?
    var messageType: MessageType

    enum MessageType {
        case success, error

        var color: Color {
            switch self {
            case .success: .green
            case .error: .red
            }
        }
    }

    var body: some View {
        if let message, !message.isEmpty {
            Text(message)
                .foregroundColor(messageType.color)
                .background(Color.clear)
        }
    }
}
