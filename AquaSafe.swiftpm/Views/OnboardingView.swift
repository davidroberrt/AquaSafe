//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 19/02/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedIndex: Int = 0 // Índice do botão atual
    @State private var timer: Timer? = nil // Timer para alterar o índice em loop
    @State private var gradientColors: [Color] = [Color.white, Color.blue]
    @Binding var selectedView: String
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    Text("AquaSafe")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    OnboardingCardView(selectedIndex: $selectedIndex)
                    
                    Button(action: {
                        if selectedIndex < 4 {
                            withAnimation { selectedIndex += 1 }
                        } else {
                            selectedView = "HomeView" // Alterna para a HomeView
                        }
                    }) {
                        Text(selectedIndex >= 4 ? "Começar" : "Próximo")
                            .frame(width: 150, height: 20)
                            .padding(20)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.bottom, 30)
                    Spacer()
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
            .onAppear {
                startTimer()
                animateGradient()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }

    private func animateGradient() {
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                DispatchQueue.main.async { // 🔹 Garante que a UI seja atualizada corretamente
                    withAnimation(.easeInOut(duration: 3)) {
                        gradientColors = [Color.accentColor, Color.white]
                    }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut(duration: 3)) {
                    gradientColors = [Color.white.opacity(0.3), Color.blue]
                }
            }
        }
    }

    // Função para iniciar o timer
    private func startTimer() {
        timer?.invalidate() // Cancela o timer anterior, se houver
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            DispatchQueue.main.async { // 🔹 Garante que a UI seja atualizada corretamente
                withAnimation(.easeInOut(duration: 1.5)) {
                    
                    // Alterar o índice a cada 1,5 segundos em loop
                    selectedIndex = (selectedIndex + 1) % 5
                }
            }
        }
    }
}

struct OnboardingCardView: View {
    @Binding var selectedIndex: Int
    @EnvironmentObject private var viewModel: LocationsViewModel

    var body: some View {
        GeometryReader { geometry in
            let center = geometry.frame(in: .global).midX
            
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: geometry.size.width * 0.05) { // Ajusta o espaçamento com base na largura da tela
                        ForEach(0..<5, id: \.self) { index in
                            GeometryReader { buttonGeometry in
                                let midX = buttonGeometry.frame(in: .global).midX
                                let scale = max(0.8, 1 - abs(midX - center) / (geometry.size.width * 0.9)) // Ajusta a escala

                                Button(action: {
                                    withAnimation {
                                        selectedIndex = index
                                        scrollProxy.scrollTo(index, anchor: .center) // Centraliza o botão clicado
                                    }
                                }) {
                                    ZStack {
                                        Image("1")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.9) // Ajuste proporcional
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 30))
                                        Spacer()
                                        RadialGradient(colors: [.clear, viewModel.buttonColor(for: index+1).opacity(0.7)], center: .bottom, startRadius: 250, endRadius: 100)

                                        VStack {
                                            Spacer()
                                            VStack {
                                                Text("Title \(index + 1)")
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                                    .bold()
                                                
                                                Text("This is a description for card \(index + 1).")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                    .padding(.top, 5)
                                            }
                                            .padding()
                                            .background(.ultraThinMaterial.opacity(0.4))
                                            .cornerRadius(30)
                                            .padding(.bottom, 10)
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .scaleEffect(scale)
                                    .animation(.easeOut(duration: 1.5), value: scale)
                                }
                                .id(index)

                                .frame(width: geometry.size.width * 0.78, height: geometry.size.height * 0.9) // Ajuste proporcional
                            }
                            .frame(width: geometry.size.width * 0.78, height: geometry.size.height * 0.9) // Ajuste proporcional
                        }
                    }
                    .padding(.horizontal, geometry.size.width * 0.10) // Ajusta o padding de acordo com a largura da tela
                }
                .onChange(of: selectedIndex) {_, newValue in
                    // Garantir que a ScrollView será atualizada quando o índice mudar
                    withAnimation {
                        scrollProxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(selectedView: .constant(""))
            .previewDevice("iPhone 14 Pro")
            .environmentObject(LocationsViewModel())
    }
}


/*
 import SwiftUI
 
 struct OnboardingView: View {
 @StateObject private var viewModel = OnboardingViewModel()
 @State private var selectedIndex: Int = 0
 @Binding var selectedView: String
 
 var body: some View {
 NavigationStack {
 ZStack {
 VStack {
 Spacer()
 Text("AquaSafe")
 .font(.largeTitle)
 .bold()
 .foregroundColor(.white)
 Spacer()
 
 HorizontalScrollButtons(selectedIndex: $selectedIndex, viewModel: viewModel)
 
 Button(action: {
 if selectedIndex < viewModel.cards.count - 1 {
 withAnimation { selectedIndex += 1 }
 } else {
 selectedView = "HomeView"
 }
 }) {
 Text(selectedIndex >= viewModel.cards.count - 1 ? "Começar" : "Próximo")
 .frame(width: 150, height: 20)
 .padding(20)
 .background(Color.white.opacity(0.2))
 .foregroundColor(.white)
 .cornerRadius(15)
 }
 .padding(.bottom, 30)
 Spacer()
 }
 }
 .background(LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
 .ignoresSafeArea()
 }
 }
 }
 
 struct HorizontalScrollButtons: View {
 @Binding var selectedIndex: Int
 @ObservedObject var viewModel: OnboardingViewModel
 
 var body: some View {
 GeometryReader { geometry in
 let center = geometry.frame(in: .global).midX
 
 ScrollViewReader { scrollProxy in
 ScrollView(.horizontal, showsIndicators: false) {
 HStack(spacing: geometry.size.width * 0.05) {
 ForEach(viewModel.cards.indices, id: \.self) { index in
 OnboardingCardView(card: viewModel.cards[index])
 .id(index)
 }
 }
 .padding(.horizontal, geometry.size.width * 0.10)
 }
 .onChange(of: selectedIndex) { _, newValue in
 withAnimation {
 scrollProxy.scrollTo(newValue, anchor: .center)
 }
 }
 }
 }
 }
 }
 
 struct OnboardingView_Previews: PreviewProvider {
 static var previews: some View {
 OnboardingView(selectedView: .constant("home"))
 }
 }
*/
