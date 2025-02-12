//
//  AquaSafeApp.swift
//  AquaSafe
//
//  Created by David Robert on 07/02/25.
//

import SwiftUI

@main
struct AquaSafeApp: App {
    // Crie a instância do LocationsDataService
    @StateObject private var locationsDataService = LocationsDataService()

    var body: some Scene {
        WindowGroup {
            // Passe o LocationsDataService para o ambiente
            ContentView()
                .environmentObject(locationsDataService) // Aqui está a chave!
        }
    }
}
