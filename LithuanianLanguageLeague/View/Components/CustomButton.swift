//
//  CustomButton.swift
//  LithuanianLanguageLeague
//
//  Created by Adil Sezer on 01/01/2024.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var iconName: String? // Optional SF Symbol name

    var body: some View {
        Button(action: action) {
            HStack {
                if let iconName {
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                }
                Text(title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(8)
            .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 15)
    }
}
