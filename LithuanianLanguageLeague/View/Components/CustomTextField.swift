//
//  CustomTextField.swift
//  LithuanianLanguageLeague
//
//  Created by Adil Sezer on 31/12/2023.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var iconName: String? // Optional SF Symbol name
    var isSecure: Bool // No default value, must be specified

    var body: some View {
        HStack {
            if let iconName {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20, alignment: .center)
                    .padding(.leading, 8)
            } else {
                Spacer()
                    .frame(width: 20)
                    .padding(.leading, 8)
            }
            if isSecure {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1)
        )
        .padding(.horizontal, 15)
    }
}
