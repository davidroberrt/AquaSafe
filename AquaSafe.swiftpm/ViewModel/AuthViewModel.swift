//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 23/02/25.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @AppStorage("storedUsername") private var storedUsername: String = ""
    @AppStorage("storedPassword") private var storedPassword: String = ""
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var name: String = ""
    @Published var errorMessage: String?

    func register() {
        guard !username.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "Please fill in all fields correctly."
            return
        }

        storedUsername = username
        storedPassword = password
        isAuthenticated = false // Após registro, direciona para login
        errorMessage = nil
    }

    func login(inputUsername: String, inputPassword: String) {
        if inputUsername == storedUsername && inputPassword == storedPassword {
            isAuthenticated = true
            errorMessage = nil
        } else {
            errorMessage = "Invalid credentials."
        }
    }

    func logout() {
        isAuthenticated = false
    }
}
