//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 11/02/25.
//  Apple I Love You <3

import SwiftUI
import MapKit
import CoreLocation

struct LocationsView: View {
    @EnvironmentObject private var viewModel: LocationsViewModel
    @StateObject private var locationManager = LocationManager()
    @State private var selectedView: String = "LocationsView"
    @State private var isMenuOpen = false
    @State private var showLocationForm: Bool = false
    @State private var newLocationName: String = ""
    @State private var newLocationDescription: String = ""
    @State private var cityName: String = ""
    @State private var streetName: String = ""
    @State private var selectedLocation: Location?
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    @State private var showPlusButtons = false  // Estado para mostrar/ocultar os botões
    @State private var selectedNumber: Int = 0  // Variável para armazenar o número selecionado
    
    
    let maxWidthForIpad: CGFloat = 700
    
    var body: some View {
        ZStack {
            SideMenuView(isMenuOpen: $isMenuOpen, selectedView: $selectedView)
            switch selectedView {
            case "HomeView":
                HelpView(selectedView: $selectedView)
            case "HelpView":
                HelpView(selectedView: $selectedView)
            case "SettingsView":
                SettingsView(selectedView: $selectedView)
            case "Signout":
                HelpView(selectedView: $selectedView)
            default:
                mapLayer
                    .ignoresSafeArea()
                    .cornerRadius(isMenuOpen ? 20 : 0)
                    .frame(
                        maxWidth: isMenuOpen ? UIScreen.main.bounds.width * 0.75 : UIScreen.main.bounds.width ,
                        maxHeight: isMenuOpen ? UIScreen.main.bounds.height * 0.75 : UIScreen.main.bounds.height
                    )
                    .offset(x: isMenuOpen ? 250 : 0)
                    .scaleEffect(isMenuOpen ? 0.85 : 1)
                    .onTapGesture {
                        isMenuOpen = false
                    }
                    .ignoresSafeArea(.all)
                
                // Conteúdo principal com animações suaves
                VStack(spacing: 0) {
                    header
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .scaleEffect(isMenuOpen ? 0.85 : 1)
                    Spacer()
                    HStack{
                        Spacer()
                        if isMenuOpen == false{
                            categoryLocationAddButtons
                                .scaleEffect(isMenuOpen ? 0.85 : 1)
                        }
                    }
                    locationsPreviewStack
                        .scaleEffect(isMenuOpen ? 0.85 : 1)
                }
                .frame(
                    maxWidth: isMenuOpen ? UIScreen.main.bounds.width * 0.75 : UIScreen.main.bounds.width,
                    maxHeight: isMenuOpen ? UIScreen.main.bounds.height * 0.75 : UIScreen.main.bounds.height
                )
                .offset(x: isMenuOpen ? 250 : 0)
                .scaleEffect(isMenuOpen ? 0.85 : 1)
                .onTapGesture {
                    isMenuOpen = false
                }
            }
        }
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
        .navigationBarHidden(true)
        .sheet(item: $viewModel.sheetLocation, onDismiss: nil) { location in
            LocationDetailView(location: location)
        }
        .sheet(isPresented: $showLocationForm) {
            LocationFormView(
                viewModel: viewModel,
                location: $selectedLocation,
                name: $newLocationName,
                description: $newLocationDescription,
                selectedNumber: $selectedNumber,
                onSave: saveLocation,
                onDelete: deleteLocation
            )
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
                Button(action: {
                    withAnimation{
                        viewModel.toggleLocationsList()
                        showPlusButtons = false
                    }
                }) {
                    Text(viewModel.mapLocation.category)
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .animation(.none, value: viewModel.mapLocation)
                        .overlay(alignment: .leading) {
                            Image(systemName: "arrow.down")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding()
                                .rotationEffect(Angle(degrees: viewModel.showLocationsList ? 180 : 0))
                        }
                }
            }
            if viewModel.showLocationsList {
                LocationsListView()
                    .frame(height: 150)
            }
        }
        .background(.thickMaterial.opacity(0.5))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var categoryLocationAddButtons: some View {
        VStack {
            // Botão "+" para mostrar os outros botões
            Button(action: {
                withAnimation {
                    showPlusButtons.toggle() // Alterna a visibilidade dos botões
                    if showPlusButtons == false {
                        selectedNumber = 0
                    }
                    if showPlusButtons == true {
                        viewModel.showLocationsList = false // close the buttons, if menu is open
                    }
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: showPlusButtons == true ? 50 : 60, height: showPlusButtons == true ? 50 : 60)
                    .foregroundColor(showPlusButtons == true ? .accentColor.opacity(0.3) : .accentColor.opacity(0.8))
                    .rotationEffect(.degrees(showPlusButtons == true ? 45 : 0 * (showPlusButtons == true ? 1 : -1) ))
            }
            .frame(maxWidth: .infinity, alignment: .trailing) // Alinha tudo à direita
            
            .padding()
            
            if showPlusButtons {
                VStack(spacing: 20) {
                    ForEach(1..<6) { number in
                        HStack {
                            // Exibe o nome apenas no botão selecionado
                            if selectedNumber == number {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 150, height: 40) // Ajuste de tamanho
                                    .overlay(
                                        Text(viewModel.buttonCategoryName(for: number))
                                            .foregroundColor(.primary)
                                            .bold()
                                    )
                                    .opacity(selectedNumber == number ? 1 : 0) // Desaparece suavemente
                                    .animation(.easeInOut(duration: 0.2), value: selectedNumber) // Transição mais rápida
                                
                            }
                            
                            // Agora, apenas o círculo é um botão
                            Button(action: {
                                withAnimation {
                                    selectedNumber = (selectedNumber == number) ? 0 : number // Alterna a seleção
                                }
                            }) {
                                Circle()
                                    .fill(viewModel.buttonColor(for: number)) // Cor dinâmica para cada botão
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image(systemName: viewModel.buttonIcon(for: number)) // Ícone dinâmico
                                            .foregroundColor(.white)
                                    )
                                    .shadow(radius: 5)
                            }
                        }
                        .padding(.trailing, 15) // Mantém alinhado à direita
                        .frame(maxWidth: .infinity, alignment: .trailing) // Alinha tudo à direita
                    }
                }
            }
        }
    }
    
    private var mapLayer: some View {
        MapReader { proxy in
            if selectedNumber != 0 {
                mapAddButton
                    .onTapGesture(coordinateSpace: .local) { tapLocation in
                        if selectedNumber != 0 { // Só adiciona localização se um botão estiver selecionado
                            if let tappedCoordinate = proxy.convert(tapLocation, from: .local) {
                                selectedCoordinate = tappedCoordinate
                                newLocationName = ""
                                newLocationDescription = ""
                                showLocationForm = true
                            }
                        }
                    }

            } else {
                Map(position: $viewModel.mapRegion, interactionModes: [.all]) {
                    //se o botao de criar nova localizacao for clicado, exibir o annotation:
                    ForEach(viewModel.locations, id: \.self.id) { location in
                        Annotation(location.category, coordinate: location.coordinates) {
                            LocationMapAnnotationView(iconName: location.icon, color: location.color)
                                .scaleEffect(viewModel.mapLocation == location ? 1 : 0.7)
                                .onTapGesture {
                                    viewModel.mapLocation = location // Força a atualização
                                    viewModel.showNextLocation(location: location)
                                    if let selectedLocation = selectedLocation, let index = viewModel.locations.firstIndex(where: { $0.id == selectedLocation.id }), index >= 5 { // NAO PERMITE ALTERAR 5
                                        showLocationForm = true
                                        return
                                    }
                                }
                        }
                    }
                }
                .mapStyle(.standard)
            }
        }
    }
    private var mapAddButton: some View {
        Map(position: $viewModel.mapRegion) {
            //se o botao de criar nova localizacao for clicado, exibir o annotation:
            if let coordinate = selectedCoordinate {
                Annotation(viewModel.buttonCategoryName(for: selectedNumber), coordinate: coordinate) {
                    LocationMapAnnotationView(iconName: viewModel.buttonIcon(for: selectedNumber), color: viewModel.buttonColor(for: selectedNumber))
                }
            }
        }
        
    }
    private var locationsPreviewStack: some View {
        ZStack {
            ForEach(viewModel.locations) { location in
                if viewModel.mapLocation == location {
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

    
    private func saveLocation() {
        guard let coordinate = selectedCoordinate else { return }
        
        // Obtenha o nome da cidade e salve no estado
        viewModel.getCityName(from: coordinate) { name in
            self.cityName = name ?? "Unknown City"
        }
        viewModel.getStreetName(from: coordinate){ name in
            self.streetName = name ?? "Unknown Street"
        }
        let location = Location(
            name: newLocationName,
            cityName: cityName,
            streetName: streetName,
            coordinates: coordinate,
            description: newLocationDescription,
            imageNames: [viewModel.buttonImageName(for: selectedNumber)],
            category: viewModel.buttonCategoryName(for: selectedNumber),
            icon: viewModel.buttonIcon(for: selectedNumber),
            color: viewModel.buttonColor(for: selectedNumber)
        )

        if let selectedLocation = selectedLocation {
            if let index = viewModel.locations.firstIndex(where: { $0.id == selectedLocation.id }) {
                if index == 0 { return } // Evita alterar a primeira localização
                viewModel.locations[index] = location
            }
        } else {
            viewModel.locations.append(location)
        }

        clearInputs()
    }

    
    // Função para excluir a localização
    private func deleteLocation() {
        if let selectedLocation = selectedLocation, let index = viewModel.locations.firstIndex(where: { $0.id == selectedLocation.id }) {
            // Impedir a exclusão do item de índice 0
            if index == 0 {
                // Não permita excluir o primeiro item
                return
            }
            viewModel.locations.remove(at: index)
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
