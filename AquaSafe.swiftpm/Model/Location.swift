//
//  File.swift
//  AquaSafe
//
//  Created by David Robert on 11/02/25.
//

import Foundation
import MapKit
import SwiftUI

struct Location: Identifiable, Equatable {
    let id = UUID() // Garante que cada local é único
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
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
        case .ruaAlagada: return "Rua Alagada"
        case .casaInundada: return "Casa Inundada"
        case .areaSegura: return "Área Segura"
        case .abrigo: return "Abrigo"
        case .pontoDeDoacao: return "Ponto de Doação"
        }
    }
    
}
