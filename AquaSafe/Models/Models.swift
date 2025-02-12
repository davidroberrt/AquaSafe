//
//  Models.swift
//  AquaSafe
//
//  Created by David Robert on 11/02/25.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable {
    
    let name: String
    var coordinates: CLLocationCoordinate2D
    let description: String
    
    // Identifiable
    var id: String {
        // name = "Colosseum"z
        // cityName = "Rome"
        // id = "ColosseumRome"
        name
    }
    
    // Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

}
