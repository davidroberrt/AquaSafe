//
//  File.swift
//  AquaSafe
//
//  Created by David Robert on 19/02/25.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var cards: [OnboardingCardModel] = [
        OnboardingCardModel(title: "Cities Paralyzed, Lives at Risk",
                            description: "Floods turn streets into rivers.\n Reporting can save lives.",
                            imageName: "flood1",
                            iconName: "drop.fill",
                            backgroundColor: .blue),
        
        OnboardingCardModel(title: "No One Is Safe from Floods.",
                            description: "Families can lose everything.\n Share affected areas for quicker help.",
                            imageName: "flood2",
                            iconName: "house.badge.exclamationmark",
                            backgroundColor: .red),
        
        OnboardingCardModel(title: "Where to Seek Refuge?",
                            description: "Shelters can mean hope.\n Mark safe locations for those in need.",
                            imageName: "flood3",
                            iconName: "tent.fill",
                            backgroundColor: .orange),
        
        OnboardingCardModel(title: "Together, We Are Stronger",
                            description: "Small gestures save lives.\n Find donation points to help others.",
                            imageName: "flood4",
                            iconName: "cross.fill",
                            backgroundColor: .purple),
        
        OnboardingCardModel(title: "Mark, Share, Save Lives",
                            description: "With AquaSafe, report floods and support your community.",
                            imageName: "flood5",
                            iconName: "shield.checkerboard",
                            backgroundColor: .green)
    ]
}

#Preview {
    OnboardingView(selectedView: .constant(""))
}
