import SwiftUI

struct OrdersHistoryView: View {
    @State private var orders: [[String: Any]] = []
    
    var body: some View {
        NavigationView {
            List(orders, id: \.self.description) { order in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(LocalizedStringKey(order["product_name"] as? String ?? ""))
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f BYN", order["price"] as? Double ?? 0.0))
                            .fontWeight(.bold)
                    }
                    Text("Адрес: \(order["address"] as? String ?? "")")
                        .font(.subheadline)
                    Text("Оплата: \(order["payment_method"] as? String ?? "")")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    if let comment = order["comment"] as? String, !comment.isEmpty {
                        Text("Коммент: \(comment)")
                            .font(.footnote)
                            .italic()
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Мои заказы")
            .onAppear {
                // При открытии экрана загружаем данные из SQLite
                orders = DatabaseManager.shared.fetchOrders()
            }
        }
    }
}
