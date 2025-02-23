//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 23/02/25.
//
import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isRegistered: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Register")
                    .font(.largeTitle)
                    .padding()

                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()


                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    viewModel.register()
                    if viewModel.errorMessage == nil {
                        isRegistered = true
                    }
                }) {
                    Text("Register")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                // Navegação condicional para HomeView
                NavigationLink(destination: LocationsView().environmentObject(LocationsViewModel()), isActive: $isRegistered) {
                    EmptyView()
                }

                NavigationLink(destination: LoginView()) {
                    Text("Already have an account? Login")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
}
