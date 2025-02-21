import SwiftUI

@main
struct MyApp: App {
    @StateObject private var vm = LocationsViewModel()
    @State private var selectedView: String = "HomeView" // Adicione uma propriedade para selectedView

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView(selectedView: .constant("")) // Passando um valor inicial para selectedView
                    .environmentObject(vm)
            }
        }
    }
}
