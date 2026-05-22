import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @State private var showingCheckout = false
    
    var body: some View {
        NavigationView {
            Group {
                if cartVM.items.isEmpty {
                    // Пустая корзина
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        Text("Cart is empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Add products from the catalog")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(cartVM.items.indices, id: \.self) { index in
                            CartItemRow(
                                item: cartVM.items[index],
                                onIncrement: {
                                    cartVM.incrementQuantity(for: cartVM.items[index])
                                },
                                onDecrement: {
                                    cartVM.decrementQuantity(for: cartVM.items[index])
                                },
                                onDelete: {
                                    cartVM.removeItem(at: index)
                                }
                            )
                        }
                        
                        // Итого
                        Section {
                            HStack {
                                Text("Total:")
                                    .font(.headline)
                                Spacer()
                                Text("\(cartVM.totalPrice, specifier: "%.2f") BYN")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Checkout") {
                        showingCheckout = true
                    }
                    .disabled(cartVM.items.isEmpty)
                }
            }
            .sheet(isPresented: $showingCheckout) {
                CheckoutView(cartVM: cartVM)
            }
        }
    }
}

// MARK: - Cart Item Row
struct CartItemRow: View {
    let item: CartItem
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Информация о товаре
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(item.product.titleKey))
                    .font(.headline)
                Text(item.product.farmName)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(item.product.price, specifier: "%.2f") BYN")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            // Кнопки +/-
            HStack(spacing: 16) {
                Button(action: onDecrement) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                
                Text("\(item.quantity)")
                    .font(.title3)
                    .frame(width: 35)
                    .multilineTextAlignment(.center)
                
                Button(action: onIncrement) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            
            // Общая стоимость за этот товар
            Text("\(item.totalPrice, specifier: "%.2f") BYN")
                .font(.headline)
                .frame(width: 70, alignment: .trailing)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 6)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
