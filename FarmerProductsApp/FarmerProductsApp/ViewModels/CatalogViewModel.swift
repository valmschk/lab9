import SwiftUI

class CatalogViewModel: ObservableObject {
    @Published var products: [FarmerProduct] = []
    
    init() {
        loadProducts()
    }
    
    func loadProducts() {
        products = [
            FarmerProduct(
                titleKey: "product_milk",
                price: 3.20,
                farmName: "Morning Dew Farm",
                category: "dairy",
                latitude: 53.9045,
                longitude: 27.5615
            ),
            FarmerProduct(
                titleKey: "product_honey",
                price: 15.00,
                farmName: "Bee Paradise",
                category: "honey",
                latitude: 53.9080,
                longitude: 27.5550
            ),
            FarmerProduct(
                titleKey: "product_cheese",
                price: 8.50,
                farmName: "Green Valley",
                category: "dairy",
                latitude: 53.9100,
                longitude: 27.5700
            ),
            FarmerProduct(
                titleKey: "product_eggs",
                price: 4.00,
                farmName: "Happy Hen Farm",
                category: "eggs",
                latitude: 53.8950,
                longitude: 27.5500
            ),
            FarmerProduct(
                titleKey: "product_bread",
                price: 2.50,
                farmName: "Organic Bakery",
                category: "bread",
                latitude: 53.9200,
                longitude: 27.5800
            )
        ]
    }
}
