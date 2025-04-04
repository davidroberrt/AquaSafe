//
//  HomeView.swift
//  AquaSafe
//
//  Created by David Robert on 18/02/25.
//

import SwiftUI

struct LocationFormView: View {
    @ObservedObject var viewModel: LocationsViewModel
    @Binding var location: Location?
    @Binding var name: String
    @Binding var description: String
    @Binding var selectedNumber: Int
    var onSave: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("City Name", text: $name)
                    TextField("Description", text: $description)
                }
                Section {
                    Button("Save") {
                        onSave()
                        selectedNumber = 0
                    }
                    .disabled(name.isEmpty || description.isEmpty)
                    
                    Button("Delete") {
                        onDelete()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Add \(viewModel.buttonCategoryName(for: selectedNumber))")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
/*
 name: "Casa Inundada",
 cityName: "Cidade X",
 coordinates: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922),
 description: "Uma casa inundada, precisa de ajuda.",
 imageNames: ["paris-eiffeltower-1"],
 category: "Casa Inundada",
 icon: "house.badge.exclamationmark",
 color: .red*/
#Preview {
    LocationFormView(
        viewModel: LocationsViewModel(), // Criando um exemplo do ViewModel
        location: .constant(nil),         // Passando nil para a location (pode ser alterado conforme necessidade)
        name: .constant(""), // Nome de exemplo
        description: .constant(""), // Descrição de exemplo
        selectedNumber: .constant(0),      // Número selecionado de exemplo
        onSave: {
            // Ação de salvar (exemplo)
            print("Salvo!")
        },
        onDelete: {
            // Ação de excluir (exemplo)
            print("Excluído!")
        }
    )
}
