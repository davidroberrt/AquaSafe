//
//  File.swift
//  AquaSafe
//
//  Created by David Robert on 11/02/25.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    
    @Published var locations: [Location] = LocationsDataService.locations
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    @Published var mapRegion: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    @Published var showLocationsList = false
    @Published var showMenuList = false
    @Published var sheetLocation: Location? = nil
    
    // Initializer to load locations and set the first one as the map center
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        
        // Ensure mapLocation is always initialized to a valid location
        if let firstLocation = locations.first {
            self.mapLocation = firstLocation
        } else {
            // Fallback: set a default location with all required fields
            self.mapLocation = Location(
                name: "Default Location",
                cityName: "Unknown City",
                coordinates: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                description: "This is a default location",
                imageNames: [],
                category: "Default",
                icon: "default_icon", // exemplo de ícone
                color: .gray // exemplo de cor
            )
        }
        
        updateMapRegion(location: mapLocation)
    }
    

    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = .region(
                MKCoordinateRegion(
                    center: location.coordinates,
                    span: mapSpan
                )
            )
        }
    }
    
    // Toggle visibility of locations list
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
    
    // Toggle visibility of menu list
    func toggleMenuList() {
        withAnimation(.easeInOut) {
            showMenuList.toggle()
        }
    }
    
    // Show next location and update map
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    // Handle the 'next' button logic
    func nextButtonPressed() {
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else {
            print("Current location not found in locations array.")
            return
        }
        
        let nextIndex = currentIndex + 1
        let nextLocation = (locations.indices.contains(nextIndex)) ? locations[nextIndex] : locations.first
        guard let location = nextLocation else { return }
        
        showNextLocation(location: location)
    }
    
    func buttonColor(for number: Int) -> Color {
        LocationCategory(rawValue: number)?.color ?? .gray
    }

    func buttonIcon(for number: Int) -> String {
        LocationCategory(rawValue: number)?.icon ?? "questionmark.circle.fill"
    }

    func buttonCategoryName(for number: Int) -> String {
        LocationCategory(rawValue: number)?.name ?? "Unknown"
    }
}
