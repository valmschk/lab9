import Foundation

// MARK: - Product Model
struct FarmerProduct: Identifiable {
    let id: UUID
    let titleLocalizationKey: String
    let price: Double
    let farmName: String
}
