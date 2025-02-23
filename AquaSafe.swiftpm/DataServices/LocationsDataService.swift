//
//  File.swift
//  AquaSafe
//
//  Created by David Robert on 14/02/25.
//

import Foundation
import MapKit

class LocationsDataService {
    
    static let locations: [Location] = [
        Location(
            name: "Dayane Oliveira",
            cityName: "Example City",
            streetName: "Water Street",
            coordinates: CLLocationCoordinate2D(latitude: 41.8895, longitude: 12.5005),
            description: "A house affected by significant flooding, requiring immediate assistance.",
            imageNames: ["flood12"],
            category: "Flooded House",
            icon: "house.badge.exclamationmark",
            color: .red
        ),
        Location(
            name: "Flooded Street",
            cityName: "Example City",
            streetName: "Main Avenue",
            coordinates: CLLocationCoordinate2D(latitude: 41.8891, longitude: 12.5022),
            description: "A completely flooded street, posing risks to pedestrians and drivers.",
            imageNames: ["flood11"],
            category: "Flooded Street",
            icon: "drop.fill",
            color: .blue
        ),
        Location(
            name: "Safe Area",
            cityName: "Example City",
            streetName: "Central Square",
            coordinates: CLLocationCoordinate2D(latitude: 41.8920, longitude: 12.4940),
            description: "An elevated area considered safe during floods.",
            imageNames: ["flood9"],
            category: "Safe Area",
            icon: "shield.checkerboard",
            color: .green
        ),
        Location(
            name: "Temporary Shelter",
            cityName: "Example City",
            streetName: "Shelter Road",
            coordinates: CLLocationCoordinate2D(latitude: 41.8930, longitude: 12.4950),
            description: "A location providing temporary shelter for the displaced.",
            imageNames: ["flood3"],
            category: "Shelter",
            icon: "tent.fill",
            color: .orange
        ),
        Location(
            name: "Donation Point",
            cityName: "Example City",
            streetName: "Donation Avenue",
            coordinates: CLLocationCoordinate2D(latitude: 41.8940, longitude: 12.4960),
            description: "A collection point for donations destined for flood victims.",
            imageNames: ["flood4"],
            category: "Donation Point",
            icon: "cross.fill",
            color: .purple
        )
    ]

    
    // Function to get locations by category
    static func getLocations(for category: String) -> [Location] {
        return locations.filter { $0.category == category }
    }
}
