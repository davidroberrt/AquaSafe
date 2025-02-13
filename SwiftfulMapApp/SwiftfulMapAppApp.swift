//
//  MyLocationsDataService.swift
//  SwiftfulMapApp
//
//  Created by David Robert on 11/02/25.
//

import SwiftUI

@main
struct SwiftfulMapAppApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
