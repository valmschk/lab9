import SwiftUI

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    func addToCart(product: FarmerProduct) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func updateQuantity(item: CartItem, delta: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let newQuantity = items[index].quantity + delta
            if newQuantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = newQuantity
            }
        }
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    func clearCart() {
        items.removeAll()
    }
}
