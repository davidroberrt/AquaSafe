//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 22/02/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var username: String = "Seu Nome"
    @State private var email: String = "email@exemplo.com"
    @State private var notificationsEnabled: Bool = true
    @State private var darkMode: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Perfil").bold()) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(username)
                                    .font(.headline)
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        TextField("Nome de Usuário", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Section(header: Text("Preferências").bold()) {
                        Toggle("Ativar Notificações", isOn: $notificationsEnabled)
                        Toggle("Modo Escuro", isOn: $darkMode)
                    }
                    
                    Section {
                        Button(action: {
                            print("Saindo da conta...")
                            // Adicione aqui a lógica de logout
                        }) {
                            HStack {
                                Spacer()
                                Text("Sair da Conta")
                                    .foregroundColor(.red)
                                    .bold()
                                Spacer()
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Configurações")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
