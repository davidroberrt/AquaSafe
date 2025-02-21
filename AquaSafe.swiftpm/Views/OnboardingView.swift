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
    @StateObject private var viewModel = LocationsViewModel() // Crie a instância do ViewModel aqui

    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 40) // Adiciona espaço acima do título
                Text("AquaSafe")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                OnboardingCardView(selectedIndex: $selectedIndex)
                
                NavigationLink(destination: HomeView()) {
                    Text(selectedIndex >= 4 ? "TO START" : "NEXT →")
                        .frame(minWidth: 300)
                        .padding(20)
                        .background(selectedIndex >= 4 ? .accentColor : Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .font(.title3)
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

    private func animateGradient() {
        Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 3)) {
                    gradientColors = gradientColors == [Color.white.opacity(0.3), Color.blue] ? [Color.accentColor, Color.brown] : [Color.white.opacity(0.3), Color.blue]
                }
            }
        }
    }


    // Função para iniciar o timer
    private func startTimer() {
        timer?.invalidate() // Cancela o timer anterior, se houver
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    selectedIndex = (selectedIndex + 1) % 5
                }
            }
        }
    }
}

struct OnboardingCardView: View {
    @Binding var selectedIndex: Int
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        GeometryReader { geometry in
            let center = geometry.frame(in: .global).midX
            
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: geometry.size.width * 0.05) { // Ajusta o espaçamento com base na largura da tela
                        ForEach(viewModel.cards.indices, id: \.self) { index in
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
                                        Image(viewModel.cards[index].imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.9) // Ajuste proporcional
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 30))
                                        Spacer()
                                        RadialGradient(colors: [.clear, viewModel.cards[index].backgroundColor], center: .bottom, startRadius: 250, endRadius: 10)

                                        VStack {
                                            Spacer()
                                            VStack {
                                                HStack{
                                                    LocationMapAnnotationView(iconName: viewModel.cards[index].iconName, color: viewModel.cards[index].backgroundColor)
                                                    Text(viewModel.cards[index].title)
                                                        .font(.title)
                                                        .foregroundColor(.white)
                                                        .bold()
                                                }
                                                
                                                Text(viewModel.cards[index].description)
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
