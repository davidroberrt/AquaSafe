//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 22/02/25.
//

import SwiftUI

struct HelpView: View {
    @State private var isMenuOpen = false
    @Binding var selectedView: String
    
    var body: some View {
        ZStack {
            SideMenuView(isMenuOpen: $isMenuOpen, selectedView: $selectedView)
            ZStack{
                Color.white
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
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
                            // O conteúdo principal da tela, por exemplo:
                            Text("Essential Tips for Floods")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .scaleEffect(isMenuOpen ? 0.70 : 1)
                            
                        }
                        .padding()
                        
                        
                        HelpSection(title: "Before the Flood", tips: [
                            ("info.circle", "Stay Informed", "Monitor weather forecasts and Civil Defense alerts.", Color.yellow),
                            ("briefcase.fill", "Prepare an Emergency Kit", "Include flashlights, batteries, food, water, and documents.", Color.yellow),
                            ("map.fill", "Identify Escape Routes", "Know the safest paths for evacuation.", Color.yellow),
                            ("exclamationmark.triangle.fill", "Avoid Risk Areas", "If you live near rivers or slopes, have an evacuation plan.", Color.yellow),
                            ("archivebox.fill", "Protect Your Belongings", "Place furniture and appliances in elevated areas.", Color.yellow)
                        ])                                    .scaleEffect(isMenuOpen ? 0.85 : 1)
                        
                        
                        HelpSection(title: "During the Flood", tips: [
                            ("figure.walk", "Stay Away from Flooded Areas", "Do not attempt to cross flooded streets.", Color.red),
                            ("car.fill", "Avoid Driving", "Only 30 cm of water can sweep a car away!", Color.red),
                            ("bolt.fill", "Turn Off Electricity", "Prevent shocks and short circuits by turning off the power supply.", Color.red),
                            ("drop.fill", "Do Not Use Contaminated Water", "Only use bottled or boiled water.", Color.red)
                        ])                                    .scaleEffect(isMenuOpen ? 0.85 : 1)
                        
                        
                        HelpSection(title: "After the Flood", tips: [
                            ("house.fill", "Avoid Returning Home Immediately", "Wait for safety confirmation.", Color.orange),
                            ("paintbrush.fill", "Sanitize Everything", "Thoroughly wash objects and the environment.", Color.orange),
                            ("exclamationmark.octagon.fill", "Be Careful with Animals", "Floods may bring snakes, rats, and scorpions.", Color.orange),
                            ("stethoscope", "Stay Alert for Health Issues", "If you experience fever, vomiting, or diarrhea, seek medical attention.", Color.orange)
                        ])                                    .scaleEffect(isMenuOpen ? 0.85 : 1)
                        
                        
                        Button(action: {
                            isMenuOpen = true
                        }) {
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding()
                        }
                        .scaleEffect(isMenuOpen ? 0.85 : 1)
                    }
                    .padding()
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

struct HelpSection: View {
    let title: String
    let tips: [(icon: String, title: String, description: String, color: Color)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.vertical, 5)
            
            ForEach(tips, id: \.title) { tip in
                HStack(alignment: .top) {
                    Image(systemName: tip.icon)
                        .foregroundColor(tip.color) // Set icon color from tip data
                    VStack(alignment: .leading) {
                        Text(tip.title).bold()
                        Text(tip.description).font(.subheadline)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(selectedView: .constant(""))
    }
}
