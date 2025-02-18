//
//  HomeView.swift
//  AquaSafe
//
//  Created by David Robert on 14/02/25.
//

import SwiftUI

struct LocationMapAnnotationView: View {
    
    let iconName: String
    let color: Color
    @State private var shadow: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(color)
                .clipShape(Circle())
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(color)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
        }
        .shadow(color: color, radius: shadow)
        /*.onAppear {
            // Alternar o tamanho do círculo
            /*Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 2)) {
                    shadow = shadow == 15.0 ? 5.0 : 15.0
                    //blurAmount = 10.0
                }
            }*/
        }*/
    }
}

// 🔍 **Prévia com todas as marcações**
struct LocationMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                LocationMapAnnotationView(iconName: "drop.fill", color: .blue) // Rua Alagada
                LocationMapAnnotationView(iconName: "house.badge.exclamationmark", color: .red) // Casa Inundada
                LocationMapAnnotationView(iconName: "shield.checkerboard", color: .green) // Local Seguro
                LocationMapAnnotationView(iconName: "tent.fill", color: .orange) // Abrigo
                LocationMapAnnotationView(iconName: "cross.fill", color: .purple) // Ponto de Doação
            }
        }
    }
}

/*
 Annotation(coordinate: location.coordinates) {
     LocationMapAnnotationView(iconName: "drop.fill", color: .blue) // Rua Alagada
 }

 */
