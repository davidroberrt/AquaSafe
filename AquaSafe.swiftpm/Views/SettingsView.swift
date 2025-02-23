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
    @StateObject private var viewModel = AuthViewModel() // Use o mesmo ViewModel se apropriado
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @AppStorage("darkMode") private var darkMode: Bool = false // Armazenar a preferência de modo escuro

    var body: some View {
        ZStack {
            // Cor de fundo que se adapta ao modo escuro
            Color(darkMode ? .black : .green).ignoresSafeArea()
            // Menu lateral
            SideMenuView(isMenuOpen: $isMenuOpen, selectedView: $selectedView)
                .animation(.linear(duration: 0.3), value: isMenuOpen)
            // Conteúdo principal
            ZStack {
                Color(darkMode ? .gray : .blue).ignoresSafeArea() // Cor do conteúdo
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "text.justify.left")
                                .font(.headline)
                                .padding()
                                .background(.thickMaterial.opacity(0.9))
                                .cornerRadius(10)
                                .fontWeight(.black)
                                .frame(height: 55)
                        }
                        Spacer()
                        Text("Settings")
                            .font(.title)
                            .padding()
                        Spacer()
                    }
                    .padding()

                    Spacer()

                    Form {
                        Section(header: Text("Account Settings")) {
                            TextField("Name", text: $viewModel.name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Username", text: $viewModel.username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        Section(header: Text("Change Password")) {
                            SecureField("New Password", text: $newPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        Section(header: Text("Appearance")) {
                            Toggle("Dark Mode", isOn: $darkMode) // Toggle para modo escuro
                        }

                        Section {
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
                        }
                    }
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .cornerRadius(isMenuOpen ? 20 : 0)
            .frame(
                maxWidth: isMenuOpen ? UIScreen.main.bounds.width * 0.75 : UIScreen.main.bounds.width,
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

    private func saveSettings() {
        // Armazena os dados no UserDefaults
        UserDefaults.standard.set(viewModel.name, forKey: "\(viewModel.username)_name")
        UserDefaults.standard.set(viewModel.username, forKey: "\(viewModel.username)_username")
        
        // Verifica se a nova senha é igual à confirmação
        if newPassword == confirmPassword && !newPassword.isEmpty {
            UserDefaults.standard.set(newPassword, forKey: viewModel.username)
            print("Password changed for user: \(viewModel.username)")
        } else {
            print("Passwords do not match or are empty.")
        }

        print("Settings saved for user: \(viewModel.username)")
    }
}
