import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @StateObject private var cartVM = CartViewModel()
    @State private var showingAlert = false
    @State private var lastAddedProduct = ""
    
    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                HStack {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey(product.titleKey))
                            .font(.headline)
                        Text(product.farmName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(product.category)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(product.price, specifier: "%.2f") BYN")
                            .fontWeight(.bold)
                        
                        Button(action: {
                            lastAddedProduct = product.titleKey
                            cartVM.addToCart(product: product)
                            showingAlert = true
                        }) {
                            Image(systemName: "cart.badge.plus")
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("catalog_title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CartView()) {
                        Image(systemName: "cart")
                    }
                }
            }
            .alert("Added to cart", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(LocalizedStringKey(lastAddedProduct))
            }
        }
    }
}
