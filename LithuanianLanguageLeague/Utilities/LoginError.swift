//
//  LoginError.swift
//  LithuanianLanguageLeague
//
//  Created by Adil Sezer on 02/01/2024.
//

import Foundation
enum LoginError: Error, LocalizedError {
    case invalidCredentials
    case networkError
    case unknownError
    case emptyEmail
    case weakPassword

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .networkError:
            return "Network error. Please check your internet connection."
        case .unknownError:
            return "An unknown error occurred. Please try again later."
        case .emptyEmail:
            return "Email field is empty. Please enter your email."
        case .weakPassword:
            return "Password is too weak. Please use a stronger password."
        }
    }
}
