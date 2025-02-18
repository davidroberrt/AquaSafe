import SwiftUI

struct OnboardingView: View {
    @State private var selectedIndex: Int = 0 // Índice do botão atual
    @State private var timer: Timer? = nil // Timer para alterar o índice em loop
    @State private var gradientColors: [Color] = [Color.white, Color.blue]

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    Text("Header")

                    HorizontalScrollButtons(selectedIndex: $selectedIndex)
                    Button("Button"){
                        
                    }
                    Spacer()
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .onAppear {
                    animateGradient()
                }
            )
            .background(.ultraThinMaterial)
            .onAppear {
                // Inicia o timer quando a view aparece
                startTimer()
            }
            .onDisappear {
                // Para o timer quando a view desaparecer
                timer?.invalidate()
            }
        }
    }

    private func animateGradient() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 3)) {
                gradientColors = [Color.accentColor, Color.white]
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 3)) {
                    gradientColors = [Color.white, Color.accentColor]
                }
            }
        }
    }

    // Função para iniciar o timer
    private func startTimer() {
        timer?.invalidate() // Cancela o timer anterior, se houver
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 3)) {
                // Alterar o índice a cada 1,5 segundos em loop
                selectedIndex = (selectedIndex + 1) % 4
            }
        }
    }
}

struct HorizontalScrollButtons: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        GeometryReader { geometry in
            let center = geometry.frame(in: .global).midX
            
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: geometry.size.width * 0.05) { // Ajusta o espaçamento com base na largura da tela
                        ForEach(0..<4, id: \.self) { index in
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
                                        Image("abrigo")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.9) // Ajuste proporcional
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 30))
                                        Spacer()
                                            .overlay{
                                                RadialGradient(colors: [.clear, .blue], center: .bottom, startRadius: 230, endRadius: 100)
                                            }

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
        OnboardingView()
            .previewDevice("iPhone 14 Pro")
        
        OnboardingView()
            .previewDevice("iPad Pro (12.9-inch) 5th generation")
    }
}
