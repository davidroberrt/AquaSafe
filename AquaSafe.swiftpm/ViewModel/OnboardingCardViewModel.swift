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
        OnboardingCardModel(title: "Abrigos",
                            description: "Encontre abrigos próximos durante enchentes.",
                            imageName: "abrigo",
                            backgroundColor: .blue),
        
        OnboardingCardModel(title: "Pontos de Doação",
                            description: "Veja locais onde você pode doar mantimentos.",
                            imageName: "doacao",
                            backgroundColor: .green),
        
        OnboardingCardModel(title: "Áreas Seguras",
                            description: "Saiba quais locais são seguros em casos de enchentes.",
                            imageName: "seguro",
                            backgroundColor: .orange),
        
        OnboardingCardModel(title: "Alertas",
                            description: "Receba notificações sobre áreas de risco.",
                            imageName: "alerta",
                            backgroundColor: .red),
        
        OnboardingCardModel(title: "Mapa",
                            description: "Acompanhe as marcações de alagamentos ao vivo.",
                            imageName: "mapa",
                            backgroundColor: .purple)
    ]
}
