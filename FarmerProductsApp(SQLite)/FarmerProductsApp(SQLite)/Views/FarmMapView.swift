import SwiftUI
import MapKit

struct FarmMapView: View {
    @State private var region: MKCoordinateRegion
    @State private var farms: [FarmerProduct] = []
    @State private var selectedFarm: FarmerProduct?
    
    init() {
        let center = CLLocationCoordinate2D(latitude: 53.9045, longitude: 27.5615)
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: farms) { farm in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: farm.latitude, longitude: farm.longitude)) {
                VStack {
                    Image(systemName: "building.2.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    Text(LocalizedStringKey(farm.titleKey))
                        .font(.caption)
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(4)
                }
                .onTapGesture {
                    selectedFarm = farm
                }
            }
        }
        .sheet(item: $selectedFarm) { farm in
            FarmDetailSheet(farm: farm)
        }
        .onAppear {
            farms = DatabaseManager.shared.fetchAllProducts()
        }
    }
}

struct FarmDetailSheet: View {
    let farm: FarmerProduct
    @Environment(\.dismiss) var dismiss
    @StateObject private var cartVM = CartViewModel()
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(LocalizedStringKey(farm.titleKey))
                    .font(.largeTitle)
                Text(farm.farmName)
                    .font(.title2)
                Text("\(farm.price, specifier: "%.2f") BYN")
                    .font(.title)
                    .foregroundColor(.green)
                Button("Add to Cart") {
                    cartVM.addToCart(product: farm)
                    showAlert = true
                }
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding()
            .navigationTitle("Farm Details")
            .toolbar {
                Button("Close") { dismiss() }
            }
            .alert("Added to Cart", isPresented: $showAlert) {
                Button("OK") { dismiss() }
            } message: {
                Text(LocalizedStringKey(farm.titleKey))
            }
        }
    }
}
