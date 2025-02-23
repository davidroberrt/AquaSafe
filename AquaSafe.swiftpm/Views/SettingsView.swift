//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 22/02/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var isMenuOpen = false
    @Binding var selectedView: String
    @StateObject private var viewModel = AuthViewModel()
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @AppStorage("darkMode") private var darkMode: Bool = false

    var body: some View {
        ZStack {
            SideMenuView(isMenuOpen: $isMenuOpen, selectedView: $selectedView)
            ZStack{
                Color(darkMode ? .black : .white)
                    .ignoresSafeArea()
                VStack {
                    HStack{
                        Button(action: {
                            withAnimation {
                                isMenuOpen.toggle() // Alterna o estado do menu
                            }
                        }) {
                            Image(systemName: "text.justify.left")
                                .font(.headline)
                                .padding()
                                .background(.thickMaterial.opacity(0.9))
                                .cornerRadius(10)
                                .fontWeight(.black)
                                .frame(height: 55)
                                .cornerRadius(10)
                        }
                        Spacer()
                        // O conteúdo principal da tela, por exemplo:
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .scaleEffect(isMenuOpen ? 0.70 : 1)
                        Spacer()
                    }
                    .padding()
                    settingsForm
                    Spacer() // Adiciona um espaço entre o formulário e o final da tela
                    saveButton // Mover o botão para o final da VStack
                }
                
            }
            .cornerRadius(isMenuOpen ? 20 : 0)
            .frame(
                maxWidth: isMenuOpen ? UIScreen.main.bounds.width * 0.75 : UIScreen.main.bounds.width ,
                maxHeight: isMenuOpen ? UIScreen.main.bounds.height * 0.75 : UIScreen.main.bounds.height
            )
            .offset(x: isMenuOpen ? 250 : 0)
            .scaleEffect(isMenuOpen ? 0.85 : 1)
            .onTapGesture {
                withAnimation {
                    isMenuOpen = false
                }
            }
            .animation(.spring, value: isMenuOpen)
        }
    }

    private var settingsForm: some View {
        Form {
            accountSection
            passwordSection
            appearanceSection
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var accountSection: some View {
        Section(header: Text("Account Settings")) {
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    private var passwordSection: some View {
        Section(header: Text("Change Password")) {
            SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    private var appearanceSection: some View {
        Section(header: Text("Appearance")) {
            Toggle("Dark Mode", isOn: $darkMode)
        }
    }

    private var saveButton: some View {
        Button(action: {
            saveSettings()
        }) {
            Text("Save Settings")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }

    private func saveSettings() {
        UserDefaults.standard.set(viewModel.name, forKey: "\(viewModel.username)_name")
        UserDefaults.standard.set(viewModel.username, forKey: "\(viewModel.username)_username")

        if newPassword == confirmPassword && !newPassword.isEmpty {
            UserDefaults.standard.set(newPassword, forKey: viewModel.username)
            print("Password changed for user: \(viewModel.username)")
        } else {
            print("Passwords do not match or are empty.")
        }

        print("Settings saved for user: \(viewModel.username)")
    }
}
