//
//  HomeView.swift
//  AquaSafe
//
//  Created by David Robert on 18/02/25.
//
import SwiftUI

struct HomeView: View {
    @State private var isMenuOpen = false
    @Binding var selectedView: String
    var body: some View {
        ZStack {
            Color.green
            // Menu lateral
            SideMenuView(isMenuOpen: $isMenuOpen, selectedView: $selectedView) // SideMenuView é o menu lateral que você deve ter configurado
                .animation(.linear(duration: 0.3), value: isMenuOpen)
            
            // Conteúdo principal
            ZStack {
                Color.blue
                VStack{
                    HStack{
                        Button(action: {
                            withAnimation {
                                isMenuOpen.toggle() // Alterna o estado do menu
                            }
                        }) {
                            Image(systemName: "text.justify.left")
                                .font(.headline)
                                .padding()
                                .background(.thickMaterial.opacity(0.9))
                                .cornerRadius(10)
                                .fontWeight(.black)
                                .frame(height: 55)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding()
                    // O conteúdo principal da tela, por exemplo:
                    Text("Welcome to the Home Screen")
                        .font(.title)
                        .padding()
                    
                    Spacer()
                }
            }
            .cornerRadius(isMenuOpen ? 20 : 0)
            .frame(
                maxWidth: isMenuOpen ? UIScreen.main.bounds.width * 0.75 : UIScreen.main.bounds.width ,
                maxHeight: isMenuOpen ? UIScreen.main.bounds.height * 0.75 : UIScreen.main.bounds.height
            )
            .offset(x: isMenuOpen ? 250 : 0)
            .scaleEffect(isMenuOpen ? 0.85 : 1)
            .onTapGesture {
                withAnimation {
                    isMenuOpen = false
                }
            }
            .animation(.spring, value: isMenuOpen)
        }
    }
}

