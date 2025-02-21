//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 20/02/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @Binding var selectedView: String
    @State private var showingOnboardingView: Bool = false

    var body: some View {
        if !showingOnboardingView{
            ZStack {
                WaterEffectView() // Add water wave
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 400, height: 400)
                    Spacer()
                    Text("AquaSafe")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.top, 100)
                    Text("Uniting forces, overcoming floods!")
                    HStack{
                        LocationMapAnnotationView(iconName: "drop.fill", color: .blue) // Rua Alagada
                        LocationMapAnnotationView(iconName: "house.badge.exclamationmark", color: .red) // Casa Inundada
                        LocationMapAnnotationView(iconName: "shield.checkerboard", color: .green) // Local Seguro
                        LocationMapAnnotationView(iconName: "tent.fill", color: .orange) // Abrigo
                        LocationMapAnnotationView(iconName: "cross.fill", color: .purple) // Ponto de Doação                Spacer()
                    }
                    .shadow(color:.blue,radius: 5)
                    .padding()
                }
                RainView() // Adds the rain effect
                    .ignoresSafeArea()
            }
            .onAppear{
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ _ in
                    withAnimation(.default){
                        DispatchQueue.main.async {
                            showingOnboardingView = true
                        }
                    }
                    
                }
            }
        } else{
            OnboardingView(selectedView: $selectedView)
        }
    }
}

struct RainView: View {
    @State private var dropCount: Int = 100 // Number of raindrops

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<dropCount, id: \.self) { _ in
                    RainDrop()
                        .frame(width: 2, height: 10)
                        .position(x: CGFloat.random(in: 0...geometry.size.width),
                                  y: CGFloat.random(in: -10...geometry.size.height))
                        .animation(Animation.linear(duration: Double.random(in: 1.0...3)).repeatForever(autoreverses: false), value: UUID())
                }
            }
        }
    }
}

struct RainDrop: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.3)) // Raindrop color
            .offset(y: offset)
            .onAppear {
                withAnimation(Animation.linear(duration: Double.random(in: 1.5...3)).repeatForever(autoreverses: false)) {
                    offset = 600 // Fall height
                }
            }
    }
}

struct WaterEffectView: View {
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.white // Cor de fundo
                .ignoresSafeArea()
            
            WaveShape(offset: waveOffset)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .blue.opacity(0.9)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    WaveShape(offset: waveOffset)
                        .fill(Color.white.opacity(0.2))
                        .scaleEffect(1.1)
                )
                .onAppear {
                    withAnimation(.easeInOut.repeatForever(autoreverses: true).speed(2)) {
                        waveOffset = 30 // O valor máximo do offset
                        
                    }
                }
        }
    }
}

struct WaveShape: Shape {
    var offset: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: 0, y: height * 0.7))

        for x in stride(from: 0, to: width, by: 1) {
            // A animação precisa ser um ciclo contínuo
            let y = height * 0.7 + sin((x / width * 2 * .pi) + offset) * 10 // Ajuste a amplitude da onda
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        // Crie uma variável de visualização de exemplo para o preview
        @State var selectedView = "Onboarding"
        SplashView(selectedView: $selectedView)
            .environmentObject(LocationsViewModel()) // Certifique-se de passar o EnvironmentObject se necessário
    }
}
