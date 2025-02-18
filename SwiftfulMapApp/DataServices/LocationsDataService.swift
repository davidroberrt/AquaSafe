//
//  HomeView.swift
//  AquaSafe
//
//  Created by David Robert on 14/02/25.
//

import Foundation
import MapKit

class LocationsDataService {
    
    static let locations: [Location] = [
        // Adicionar locais de exemplo para cada categoria
        Location(
            name: "Casa Inundada",
            cityName: "Cidade X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922),
            description: "Uma casa inundada, precisa de ajuda.",
            imageNames: ["paris-eiffeltower-1"],
            category: "Casa Inundada",
            icon: "house.badge.exclamationmark",
            color: .red
        ),
        Location(
            name: "Rua Alagada",
            cityName: "Cidade X",
            coordinates: CLLocationCoordinate2D(latitude: 42.8902, longitude: 12.4922),
            description: "Rua alagada, perigosa.",
            imageNames: ["paris-eiffeltower-1"],
            category: "Rua Alagada",
            icon: "drop.fill",
            color: .blue
        ),
        Location(
            name: "Área Segura",
            cityName: "Cidade X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8920, longitude: 12.4940),
            description: "Área segura durante a inundação.",
            imageNames: ["paris-eiffeltower-1"],
            category: "Área Segura",
            icon: "shield.checkerboard",
            color: .green
        ),
        Location(
            name: "Abrigo",
            cityName: "Cidade X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8930, longitude: 12.4950),
            description: "Abrigo temporário para vítimas.",
            imageNames: ["paris-eiffeltower-1"],
            category: "Abrigo",
            icon: "tent.fill",
            color: .yellow
        ),
        Location(
            name: "Ponto de Doação",
            cityName: "Cidade X",
            coordinates: CLLocationCoordinate2D(latitude: 41.8940, longitude: 12.4960),
            description: "Ponto de doação de suprimentos.",
            imageNames: ["paris-eiffeltower-1"],
            category: "Ponto de Doação",
            icon: "cross.fill",
            color: .purple
        )
    ]
    
    // Função para obter localizações por categoria
    static func getLocations(for category: String) -> [Location] {
        return locations.filter { $0.category == category }
    }
}
