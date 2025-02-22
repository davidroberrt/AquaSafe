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
        // Add sample locations for each category
        Location(
            name: "Flooded House",
            cityName: "City X",
            streetName: "Street X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8895, longitude: 12.5005),
            description: "A flooded house in need of help.",
            imageNames: ["flood12"],
            category: "Flooded House",
            icon: "house.badge.exclamationmark",
            color: .red
        ),
        Location(
            name: "Flooded Street",
            cityName: "City X",
            streetName: "Street X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8891, longitude: 12.5022),
            description: "Flooded street, dangerous.",
            imageNames: ["flood11"],
            category: "Flooded Street",
            icon: "drop.fill",
            color: .blue
        ),
        Location(
            name: "Safe Area",
            cityName: "City X",
            streetName: "Street X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8920, longitude: 12.4940),
            description: "Safe area during the flood.",
            imageNames: ["flood9"],
            category: "Safe Area",
            icon: "shield.checkerboard",
            color: .green
        ),
        Location(
            name: "Shelter",
            cityName: "City X",
            streetName: "Street X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8930, longitude: 12.4950),
            description: "Temporary shelter for victims.",
            imageNames: ["flood3"],
            category: "Shelter",
            icon: "tent.fill",
            color: .orange
        ),
        Location(
            name: "Donation Point",
            cityName: "City X",
            streetName: "Street X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8940, longitude: 12.4960),
            description: "Donation point for supplies.",
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
