import SwiftUI

struct CartView: View {
    @StateObject private var cartVM = CartViewModel()
    @State private var showingCheckout = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cartVM.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey(item.product.titleKey))
                                .font(.headline)
                            Text(item.product.farmName)
                                .font(.caption)
                        }
                        Spacer()
                        HStack {
                            Button("-") {
                                cartVM.updateQuantity(item: item, delta: -1)
                            }
                            .buttonStyle(.bordered)
                            
                            Text("\(item.quantity)")
                                .frame(width: 40)
                            
                            Button("+") {
                                cartVM.updateQuantity(item: item, delta: 1)
                            }
                            .buttonStyle(.bordered)
                        }
                        Text("\(item.totalPrice, specifier: "%.2f") BYN")
                            .frame(width: 80)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { cartVM.removeItem(at: $0) }
                }
                
                Section("Total:") {
                    HStack {
                        Text("Total:")
                            .font(.headline)
                        Spacer()
                        Text("\(cartVM.totalPrice, specifier: "%.2f") BYN")
                            .font(.title2)
                            .bold()
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
