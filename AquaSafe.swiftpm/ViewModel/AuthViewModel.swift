//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 23/02/25.
//

import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?

    func login() {
        // Recupera a senha armazenada no UserDefaults
        if let storedPassword = UserDefaults.standard.string(forKey: username) {
            if storedPassword == password {
                isLoggedIn = true
                errorMessage = nil
            } else {
                errorMessage = "Invalid username or password."
            }
        } else {
            errorMessage = "User not found."
        }
    }

    func register() {
        // Valida os campos
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required."
            return
        }
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        }

        // Armazena a senha no UserDefaults
        UserDefaults.standard.set(password, forKey: username)
        UserDefaults.standard.set(name, forKey: "\(username)_name")
        
        errorMessage = nil
        print("User registered: \(username)")
    }
}
