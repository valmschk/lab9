import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @EnvironmentObject var cartVM: CartViewModel  // ← получаем общий экземпляр
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
                            cartVM.addToCart(product: product)
                            lastAddedProduct = product.titleKey
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
                    NavigationLink(destination: CartView().environmentObject(cartVM)) {
                        Image(systemName: "cart")
                            .overlay(
                                Text("\(cartVM.items.count)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 10, y: -10)
                                    .opacity(cartVM.items.count > 0 ? 1 : 0)
                            )
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
