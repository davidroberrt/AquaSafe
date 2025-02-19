//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 11/02/25.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    @AppStorage("selectedIndex") private var selectedIndex: Int = 0  // Armazenando o índice selecionado de forma persistente
    
    var body: some View {
        GeometryReader { geometry in
            let center = geometry.frame(in: .global).midX // Posição central da tela
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollProxy in
                    HStack(spacing: 20) {
                        
                        // Spacer no início para empurrar os itens para o centro
                        Spacer(minLength: geometry.size.width * 0.3)
                        
                        // Loop nos itens de localização
                        ForEach(vm.locations) { location in
                            GeometryReader { buttonGeometry in
                                let midX = buttonGeometry.frame(in: .global).midX
                                
                                // Calculando o zoom com base na proximidade do centro
                                let scale = max(0.6, 1 - abs(midX - center) / (geometry.size.width * 0.9))
                                
                                Button {
                                    // Ao clicar, atualizamos o índice e movemos o item para o centro
                                    if let index = vm.locations.firstIndex(where: { $0.id == location.id }) {
                                        selectedIndex = index // Persistindo o índice selecionado
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            scrollProxy.scrollTo(location.id, anchor: .center)
                                            // Espera meio segundo (tempo da animação) antes de chamar a função
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                vm.showNextLocation(location: location)
                                            }
                                        }
                                    }
                                } label: {
                                    listRowView(location: location, scale: scale) // Passando o scale para o item
                                }
                                .frame(width: 130, height: 150) // Ajuste para o tamanho do card
                                .clipped()
                                .scaleEffect(scale) // Aplicando a escala
                                .animation(.easeOut(duration: 0.5), value: scale) // Suaviza a transição de zoom e rotação
                            }
                            .frame(width: 130, height: 150) // Ajuste para o tamanho fixo do card
                        }
                        
                        // Spacer no final para manter os itens centralizados
                        Spacer(minLength: geometry.size.width * 0.3)
                    }
                    .onAppear {
                        // Ao aparecer, centraliza o item com base no selectedIndex
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if !vm.locations.isEmpty, selectedIndex < vm.locations.count {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    scrollProxy.scrollTo(vm.locations[selectedIndex].id, anchor: .center)
                                }
                            } else {
                                selectedIndex = 0  // Garante um índice válido
                            }
                        }
                    }
                }
                .background(Color.clear) // Definindo o fundo da ScrollView como transparente
            }
            .background(Color.clear) // Definindo o fundo da ScrollView como transparente
        }
        .background(Color.clear) // Definindo o fundo do GeometryReader como transparente
    }
    
    private func listRowView(location: Location, scale: CGFloat) -> some View {
        VStack {
            if location.imageNames.first != nil {
                Image(systemName: location.icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .padding()
                    .foregroundStyle(Color(location.color))
            }
            
            VStack(alignment: .center) {
                Text(location.category)
                    .font(.headline)
                    .lineLimit(1)
                Text(location.cityName)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: 130, height: 100) // Largura fixa para cada item
        .padding(.vertical, 5)
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(LocationsViewModel())
    }
}
