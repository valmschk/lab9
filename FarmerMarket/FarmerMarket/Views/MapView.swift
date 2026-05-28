import SwiftUI
import MapKit

// Модель для точек на карте
struct FarmLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MarketMapView: View {
    // 1. Добавляем свойство среды для закрытия экрана
    @Environment(\.dismiss) var dismiss
    
    // Координаты центра (Минск)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.9045, longitude: 27.5615),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // Моковые точки ферм
    let farms = [
        FarmLocation(name: "Утренняя роса", coordinate: CLLocationCoordinate2D(latitude: 53.915, longitude: 27.570)),
        FarmLocation(name: "Пчелиный рай", coordinate: CLLocationCoordinate2D(latitude: 53.890, longitude: 27.540))
    ]
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: farms) { farm in
            MapAnnotation(coordinate: farm.coordinate) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                    Text(farm.name)
                        .font(.caption)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(4)
                }
            }
        }
        .navigationTitle("Карта хозяйств")
        .navigationBarTitleDisplayMode(.inline)
        // 2. Добавляем кнопку "Готово" в верхний правый угол
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово") {
                    dismiss() // Этот метод закрывает всплывающий экран
                }
                .fontWeight(.bold)
            }
        }
    }
}
