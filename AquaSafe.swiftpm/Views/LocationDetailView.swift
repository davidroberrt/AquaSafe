//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 14/02/25.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    let location: Location
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer
                    Button("Go to Apple Maps") {
                        openMaps()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(location: LocationsDataService.locations.first!)
            .environmentObject(LocationsViewModel())
    }
}

extension LocationDetailView {
    
    private var imageSection: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) {
                Image($0)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var mapLayer: some View {
        Map(
            initialPosition: .region(
                MKCoordinateRegion(
                    center: location.coordinates,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        ) {
            Annotation("",coordinate: location.coordinates) {
                LocationMapAnnotationView(iconName: location.icon, color: location.color)
                    .shadow(radius: 10)
            }
        }
        .allowsHitTesting(false) // Previne a interação com o mapa
        .aspectRatio(1, contentMode: .fit) // Mantém o aspecto fixo
        .cornerRadius(30) // Adiciona borda arredondada ao mapa
    }
    
    private var backButton: some View {
        Button {
            vm.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }

    private func openMaps() {
        let coordinate = location.coordinates
        
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionDistance,
            longitudinalMeters: regionDistance
        )
        
        // Criar o MKMapItem com as coordenadas
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        
        // Definir o nome da localização para o MapItem
        mapItem.name = location.category
        
        // Abrir o Mapas
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ])
    }
}
