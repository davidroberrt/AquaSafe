//
//  SwiftUIView.swift
//  AquaSafe
//
//  Created by David Robert on 20/02/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @Binding var selectedView: String
    @State private var showingOnboardingView: Bool = false
    @State private var timer: Timer?

    var body: some View {
        if !showingOnboardingView {
            ZStack {
                WaterEffectView()
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 400, height: 400)
                    Spacer()
                    Text("AquaSafe")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.top, 100)
                    Text("Uniting forces, overcoming floods!")
                    HStack {
                        LocationMapAnnotationView(iconName: "drop.fill", color: .blue)
                        LocationMapAnnotationView(iconName: "house.badge.exclamationmark", color: .red)
                        LocationMapAnnotationView(iconName: "shield.checkerboard", color: .green)
                        LocationMapAnnotationView(iconName: "tent.fill", color: .orange)
                        LocationMapAnnotationView(iconName: "cross.fill", color: .purple)
                    }
                    .shadow(color:.blue, radius: 5)
                    .padding()
                }
                RainView()
                    .ignoresSafeArea()
            }
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    withAnimation(.easeInOut) {
                        DispatchQueue.main.async {
                            showingOnboardingView = true
                        }
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        } else {
            OnboardingView(selectedView: $selectedView)
        }
    }
}

struct RainView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<100, id: \ .self) { _ in
                    RainDrop()
                        .frame(width: 2, height: 12)
                        .position(x: CGFloat.random(in: 0...geometry.size.width),
                                  y: CGFloat.random(in: -10...geometry.size.height))
                }
            }
        }
    }
}

struct RainDrop: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.3))
            .offset(y: offset)
            .onAppear {
                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                    offset = 600
                }
            }
    }
}

struct WaterEffectView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            WaveShape()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .blue.opacity(0.9)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    WaveShape()
                        .fill(Color.white.opacity(0.2))
                        .scaleEffect(1.1)
                )
        }
    }
}

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height * 0.7))
        for x in stride(from: 0, to: width, by: 1) {
            let y = height * 0.7 + sin((x / width * 2 * .pi)) * 10
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        return path
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedView = "Onboarding"
        SplashView(selectedView: $selectedView)
            .environmentObject(LocationsViewModel())
    }
}
