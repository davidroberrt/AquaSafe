//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 19/02/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedIndex: Int = 0
    @State private var timer: Timer? = nil
    @Binding var selectedView: String
    @StateObject private var viewModel = LocationsViewModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @AppStorage("darkMode") private var darkMode: Bool = false // Armazenar a preferência de modo escuro
    
    var body: some View {
        ZStack {
            VStack {
                Text("AquaSafe")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                OnboardingCardView(selectedIndex: $selectedIndex)
                
                if selectedIndex < onboardingViewModel.cards.count - 1 {
                    Button(action: {
                        selectedIndex += 1
                    }) {
                        Text("NEXT")
                            .frame(minWidth: 300)
                            .padding(20)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .font(.title3)
                    }
                } else {
                    // Último cartão
                    NavigationLink(destination: CredentialView().environmentObject(AuthViewModel())) {
                        Text("TO START")
                            .frame(minWidth: 300)
                            .padding(20)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .font(.title3)
                    }
                }
            }
            .padding(.bottom, 30)
            
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [darkMode == true ? .black : .white, .blue ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationBarHidden(true)
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

/*
 NavigationLink(destination: LocationsView().environmentObject(viewModel)) {
     Text(selectedIndex >= 4 ? "TO START" : "NEXT →")
         .frame(minWidth: 300)
         .padding(20)
         .background(selectedIndex >= 4 ? .accentColor : Color.white.opacity(0.2))
         .foregroundColor(.white)
         .cornerRadius(15)
         .font(.title3)
 }
 */
