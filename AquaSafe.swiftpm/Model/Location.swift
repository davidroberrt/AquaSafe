//
//  File.swift
//  AquaSafe
//
//  Created by David Robert on 11/02/25.
//

import Foundation
import MapKit
import SwiftUI

struct User: Codable {
    var username: String
    var password: String
}


struct Location: Identifiable, Equatable {
    let id = UUID() // Garante que cada local é único
    let name: String
    let cityName: String
    let streetName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    var imageNames: [String]
    let category: String  // Nova propriedade de categoria
    let icon: String      // Ícone para exibir
    let color: Color     // Cor para exibir
    
    // Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
struct CardsContent: Identifiable{
    let id = UUID()
    let title: String
    let description: String
}
enum LocationCategory: Int, CaseIterable {
    case ruaAlagada = 1
    case casaInundada
    case areaSegura
    case abrigo
    case pontoDeDoacao

    var color: Color {
        switch self {
        case .ruaAlagada: return .blue
        case .casaInundada: return .red
        case .areaSegura: return .green
        case .abrigo: return .orange
        case .pontoDeDoacao: return .purple
        }
    }

    var icon: String {
        switch self {
        case .ruaAlagada: return "drop.fill"
        case .casaInundada: return "house.badge.exclamationmark"
        case .areaSegura: return "shield.checkerboard"
        case .abrigo: return "tent.fill"
        case .pontoDeDoacao: return "cross.fill"
        }
    }

    var name: String {
        switch self {
        case .ruaAlagada: return "Flooded Street"
        case .casaInundada: return "Flooded House"
        case .areaSegura: return "Safe Area"
        case .abrigo: return "Shelter"
        case .pontoDeDoacao: return "Donation Point"
        }
    }
    
    var image: String {
        switch self {
        case .ruaAlagada: return "flood6"
        case .casaInundada: return "flood7"
        case .areaSegura: return "flood10"
        case .abrigo: return "flood9"
        case .pontoDeDoacao: return "flood8"
        }
    }
    
}
