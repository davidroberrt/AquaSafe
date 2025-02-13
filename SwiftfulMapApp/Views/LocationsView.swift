//
//  LocationsView.swift
//  SwiftfulMapApp
//
//  Created by Nick Sarno on 11/27/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationsView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    @State private var isMenuOpen = false
    @State private var showLocationForm: Bool = false
    @State private var newLocationName: String = ""
    @State private var newLocationDescription: String = ""
    @State private var cityName: String = ""
    @State private var imageNames: String = ""
    @State private var selectedLocation: Location?
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    let maxWidthForIpad: CGFloat = 700
    
    var body: some View {
        ZStack {

            // Menu Lateral
            SideMenuView(isMenuOpen: $isMenuOpen)
                .animation(.linear(duration: 0.3), value: isMenuOpen)
            mapLayer.ignoresSafeArea()
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
                .ignoresSafeArea(.all)
                .animation(.spring, value: isMenuOpen)

            // Conteúdo principal com animações suaves
            VStack(spacing: 0) {
                header
                    .padding()
                    .frame(maxWidth: maxWidthForIpad)
                    .scaleEffect(isMenuOpen ? 0.85 : 1)
                    .animation(.spring, value: isMenuOpen)
                
                Spacer()
                
                locationsPreviewStack
                    .scaleEffect(isMenuOpen ? 0.85 : 1)
                    .animation(.spring, value: isMenuOpen)
            }
            .frame(
                maxWidth: isMenuOpen ? UIScreen.main.bounds.width * 0.75 : UIScreen.main.bounds.width,
                maxHeight: isMenuOpen ? UIScreen.main.bounds.height * 0.75 : UIScreen.main.bounds.height
            )
            .offset(x: isMenuOpen ? 250 : 0)
            .scaleEffect(isMenuOpen ? 0.85 : 1)
            .animation(.spring, value: isMenuOpen)
            .onTapGesture {
                withAnimation {
                    isMenuOpen = false
                }
            }
        }
        .sheet(item: $vm.sheetLocation, onDismiss: nil) { location in
                   LocationDetailView(location: location)
               }
        .sheet(isPresented: $showLocationForm) {
            // Exibir o formulário para adicionar ou editar a localização
            LocationFormView(location: $selectedLocation, name: $newLocationName, description: $newLocationDescription, onSave: saveLocation, onDelete: deleteLocation)
        }
    }
}
struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationsViewModel())
    }
}

extension LocationsView {
    
    private var header: some View {
        VStack {
            HStack {
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
                Button(action: vm.toggleLocationsList) {
                    Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .animation(.none, value: vm.mapLocation)
                        .overlay(alignment: .leading) {
                            Image(systemName: "arrow.down")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding()
                                .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                        }
                }
            }
            if vm.showLocationsList {
                LocationsListView()
                    .frame(height: 150)
            }
        }
        .background(.thickMaterial.opacity(0.5))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        MapReader { proxy in
            Map(position: $vm.mapRegion) {
                //se o botao de criar nova localizacao for clicado, exibir o annotation:
                if let coordinate = selectedCoordinate {
                    Annotation("üi", coordinate: coordinate) {
                        LocationMapAnnotationView(iconName: "house.badge.exclamationmark", color: .red)
                    }
                }
                ForEach(vm.locations) { location in
                    Annotation(location.name, coordinate: location.coordinates) {
                        LocationMapAnnotationView(iconName: "house.badge.exclamationmark", color: .red)
                            .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                            .onTapGesture {
                                // Ao clicar na marcação, habilitar a edição ou exclusão
                                selectedLocation = location
                                newLocationName = location.name
                                newLocationDescription = location.description
                                vm.showNextLocation(location: location)
                                if let selectedLocation = selectedLocation, let index = vm.locations.firstIndex(where: { $0.id == selectedLocation.id }), index >= 5 { // NAO PERMITE ALTERAR 5
                                    showLocationForm = true
                                    return
                                }
                            }
                    }
                }
            }
            //se o botao de criar nova localizacao for clicado, exibir o annotation:

            .onTapGesture { location in
                if let tappedCoordinate = proxy.convert(location, from: .local) {
                    selectedCoordinate = tappedCoordinate
                    newLocationName = ""
                    newLocationDescription = ""
                    showLocationForm = true
                }
            }
        }
    }
    
    private var locationsPreviewStack: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
            }
        }
    }


    
    // Função para salvar a localização
    private func saveLocation() {
        guard let coordinate = selectedCoordinate else { return }
        
        let location = Location(name: newLocationName, cityName: cityName, coordinates: coordinate, description: newLocationDescription, imageNames: [""], link: "")
        
        if let selectedLocation = selectedLocation {
            // Impedir a alteração do item de índice 0
            if let index = vm.locations.firstIndex(where: { $0.id == selectedLocation.id }) {
                if index == 0 {
                    // Não permita alteração do primeiro item
                    return
                }
                vm.locations[index] = location
            }
        } else {
            // Adicionar nova localização
            vm.locations.append(location)
        }
        
        clearInputs()
    }

    
    // Função para excluir a localização
    private func deleteLocation() {
        if let selectedLocation = selectedLocation, let index = vm.locations.firstIndex(where: { $0.id == selectedLocation.id }) {
            // Impedir a exclusão do item de índice 0
            if index == 0 {
                // Não permita excluir o primeiro item
                return
            }
            vm.locations.remove(at: index)
        }
        clearInputs()
    }

    
    // Limpar campos e estados
    private func clearInputs() {
        newLocationName = ""
        newLocationDescription = ""
        selectedCoordinate = nil
        selectedLocation = nil
        showLocationForm = false
    }
}

import SwiftUI

struct LocationFormView: View {
    @Binding var location: Location?
    @Binding var name: String
    @Binding var description: String
    var onSave: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack {
            TextField("Nome da Localização", text: $name)
            TextField("Descrição da localização", text: $description)
            
            HStack {
                Button("Salvar") {
                    onSave()
                }
                .disabled(name.isEmpty || description.isEmpty)
                
                if location != nil {
                    Button("Excluir") {
                        onDelete()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}
