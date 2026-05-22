import Foundation

struct FarmerProduct: Identifiable, Codable {
    let id: UUID
    let titleKey: String
    let price: Double
    let farmName: String
    let category: String
    let latitude: Double
    let longitude: Double
    
    init(id: UUID = UUID(), titleKey: String, price: Double, farmName: String, category: String, latitude: Double, longitude: Double) {
        self.id = id
        self.titleKey = titleKey
        self.price = price
        self.farmName = farmName
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
    }
}
