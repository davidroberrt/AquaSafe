//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 23/02/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Text("Register")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Full Name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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


                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    viewModel.register()
                    if viewModel.errorMessage == nil {
                        navigationPath.append("LocationsView")
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

                Button(action: {
                    navigationPath.append("LoginView")
                }) {
                    Text("Already have an account? Login")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationDestination(for: String.self) { viewName in
                switch viewName {
                case "LocationsView":
                    LocationsView().environmentObject(LocationsViewModel())
                case "LoginView":
                    LoginView()
                default:
                    EmptyView()
                }
            }
        }
    }
}
