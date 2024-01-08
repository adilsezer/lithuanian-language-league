import SwiftUI

struct MessageView: View {
    var message: String?
    var messageType: MessageType

    enum MessageType {
        case success, error

        var color: Color {
            switch self {
            case .success: return .green
            case .error: return .red
            }
        }
    }

    var body: some View {
        if let message = message, !message.isEmpty {
            Text(message)
                .foregroundColor(messageType.color)
                .background(Color.clear)
        }
    }
}
