//
//  ContentView.swift
//  AquaSafe
//
//  Created by David Robert on 07/02/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @State private var blurAmount: CGFloat = 5.0
    @State private var waveOffset: CGFloat = 0
    @State private var circleSize: CGFloat = 20.0
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    // Variavel selecionar o mapa.
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    // Lista para armazenar as coordenadas
    @State private var coordinates: [CLLocationCoordinate2D] = []
    
    var body: some View {
        MapReader { proxy in
            Map(position: $position) {
                if let coordinate = selectedCoordinate {
                    Annotation("Alagamento", coordinate: coordinate) {
                        VStack {
                            boddy
                        }
                    }
                }
                // adicionando polilinha
                MapPolyline(coordinates: coordinates)
                    .stroke(Color.blue, lineWidth: 3)
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    selectedCoordinate = coordinate
                    print("Coordenada marcada: \(coordinate.latitude), \(coordinate.longitude)")
                }
                // adicionando polilinha
                if let coordinate2 = proxy.convert(position, from: .local) {
                    coordinates.append(coordinate2)
                    selectedCoordinate = coordinates

                }
            }
        }
        .mapControls {
            MapPitchToggle()
            MapUserLocationButton()
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }

    var boddy: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: circleSize, height: circleSize)
                .blur(radius: blurAmount)
                .offset(y:waveOffset)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .blur(radius: 30)
                )
                .onAppear {
                    // Alternar o tamanho do círculo
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            circleSize = circleSize == 20.0 ? 30.0 : 20.0
                            blurAmount = 10.0

                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
