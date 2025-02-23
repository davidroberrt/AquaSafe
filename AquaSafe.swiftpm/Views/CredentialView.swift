//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 15/02/25.
//

import SwiftUI

struct CredentialView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var viewModel2: LocationsViewModel

    var body: some View {
        if viewModel.isAuthenticated {
            LocationsView().environmentObject(LocationsViewModel()).environmentObject(AuthViewModel())
        } else {
            LoginView()
        }
    }
}
