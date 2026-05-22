import SwiftUI

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    func addToCart(product: FarmerProduct) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            // Товар уже есть - увеличиваем количество
            items[index].quantity += 1
        } else {
            // Новый товар
            items.append(CartItem(product: product, quantity: 1))
        }
        print("✅ Added: \(product.titleKey), total items: \(items.count)")
    }
    
    func incrementQuantity(for item: CartItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += 1
            print("➕ Incremented: \(item.product.titleKey), new quantity: \(items[index].quantity)")
        }
    }
    
    func decrementQuantity(for item: CartItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if items[index].quantity > 1 {
                items[index].quantity -= 1
                print("➖ Decremented: \(item.product.titleKey), new quantity: \(items[index].quantity)")
            } else {
                // Если количество 1, удаляем товар
                removeItem(at: index)
                print("🗑️ Removed: \(item.product.titleKey) (quantity became 0)")
            }
        }
    }
    
    func removeItem(at index: Int) {
        let removed = items.remove(at: index)
        print("🗑️ Removed: \(removed.product.titleKey)")
    }
    
    func removeItem(item: CartItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
            print("🗑️ Removed: \(item.product.titleKey)")
        }
    }
    
    func clearCart() {
        items.removeAll()
        print("🗑️ Cart cleared")
    }
}
