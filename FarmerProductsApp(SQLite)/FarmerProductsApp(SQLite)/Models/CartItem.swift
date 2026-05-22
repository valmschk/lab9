import Foundation

struct CartItem: Identifiable, Codable {
    var id = UUID()
    let product: FarmerProduct
    var quantity: Int
    
    var totalPrice: Double {
        product.price * Double(quantity)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, product, quantity
    }
}
