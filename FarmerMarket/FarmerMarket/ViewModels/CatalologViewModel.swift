import Foundation
import Combine

// MARK: - Catalog ViewModel
class CatalogViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var products: [FarmerProduct] = []
    
    // MARK: - Initialization
    init() {
        fetchProducts()
    }
    
    // MARK: - Data Fetching
    private func fetchProducts() {
        // Пока используем моковые данные. Позже сюда добавим чтение из SQLite
        self.products = [
            FarmerProduct(id: UUID(), titleLocalizationKey: "product_milk", price: 3.20, farmName: "Утренняя роса"),
            FarmerProduct(id: UUID(), titleLocalizationKey: "product_honey", price: 15.00, farmName: "Пчелиный рай")
        ]
    }
}
