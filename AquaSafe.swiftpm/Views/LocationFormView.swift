import SwiftUI
import PhotosUI

struct LocationFormView: View {
    @ObservedObject var viewModel: LocationsViewModel
    @Binding var location: Location?
    @Binding var name: String
    @Binding var description: String
    @Binding var selectedNumber: Int
    @State private var streetName: String = ""
    @State private var streetNumber: String = ""
    @State private var cityName: String = ""
    @State private var stateName: String = ""
    @State private var postalCode: String = ""
    @State private var selectedItem: PhotosPickerItem? // Propriedade para o item do picker
    @State private var selectedImage: UIImage? // Propriedade para a imagem
    
    var onSave: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General Information")) {
                    TextField("Your Name", text: $name)
                    TextField("Description", text: $description)
                }
                Section(header: Text("Address Information")) {
                    TextField("Street Name", text: $streetName)
                    TextField("Street Number", text: $streetNumber)
                    TextField("City", text: $cityName)
                    TextField("State", text: $stateName)
                    TextField("Postal Code", text: $postalCode)
                }
                Section(header: Text("Image")) {
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("Select an Image")
                    }
                    .onChange(of: selectedItem) {_, newItem in
                        // Extrai a imagem do PhotosPickerItem
                        guard let newItem else { return }
                        Task {
                            // Obtém a imagem
                            if let data = try? await newItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                            }
                        }
                    }
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
