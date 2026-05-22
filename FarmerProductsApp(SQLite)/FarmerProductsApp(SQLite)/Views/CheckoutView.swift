import SwiftUI

struct CheckoutView: View {
    @ObservedObject var cartVM: CartViewModel
    @State private var selectedPayment = "online"
    @State private var address = ""
    @State private var showingConfirmation = false
    @Environment(\.dismiss) var dismiss
    
    let paymentMethods = [
        ("online", "Payment Online"),
        ("erip", "ERIP"),
        ("card", "Card Terminal"),
        ("cash", "Cash")
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Delivery Address") {
                    TextField("Enter address", text: $address)
                        .textFieldStyle(.roundedBorder)
                }
                
                Section("Payment Method") {
                    ForEach(paymentMethods, id: \.0) { method in
                        HStack {
                            Text(LocalizedStringKey(method.1))
                            Spacer()
                            if selectedPayment == method.0 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedPayment = method.0
                        }
                    }
                }
                
                Section("Order Summary") {
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text("\(cartVM.totalPrice, specifier: "%.2f") BYN")
                            .bold()
                    }
                }
            }
            .navigationTitle("Checkout")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Place Order") {
                        placeOrder()
                    }
                    .disabled(address.isEmpty)
                }
            }
            .alert("Order Confirmed!", isPresented: $showingConfirmation) {
                Button("OK") {
                    dismiss()
                    cartVM.clearCart()
                }
            } message: {
                Text("Your order has been placed successfully")
            }
        }
    }
    
    private func placeOrder() {
        let userId = DatabaseManager.shared.getCurrentUserId()
        DatabaseManager.shared.saveOrder(
            userId: userId,
            products: cartVM.items,
            totalPrice: cartVM.totalPrice,
            paymentMethod: selectedPayment,
            address: address
        )
        showingConfirmation = true
    }
}
