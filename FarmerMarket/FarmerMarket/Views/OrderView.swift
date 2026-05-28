import SwiftUI

struct OrderView: View {
    let product: FarmerProduct
    
    // Состояния для полей формы
    @State private var address: String = ""
    @State private var comment: String = ""
    @State private var selectedPayment: String = "Онлайн"
    @State private var isOrderSaved: Bool = false
    
    // Варианты оплаты по ТЗ
    let paymentMethods = ["Онлайн", "ЕРИП", "Терминал", "Наличные"]
    
    var body: some View {
        Form {
            Section(header: Text("Товар")) {
                Text(LocalizedStringKey(product.titleLocalizationKey))
                    .font(.headline)
                Text(product.farmName)
                    .foregroundColor(.gray)
                Text(String(format: "%.2f BYN", product.price))
                    .fontWeight(.bold)
            }
            
            Section(header: Text("Доставка и оплата")) {
                TextField("Адрес доставки", text: $address)
                
                Picker("Способ оплаты", selection: $selectedPayment) {
                    ForEach(paymentMethods, id: \.self) { method in
                        Text(method).tag(method)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Комментарий к заказу")) {
                TextField("Например: позвонить за 15 минут", text: $comment)
            }
            
            Button(action: {
                saveOrderToDatabase()
            }) {
                Text("Подтвердить заказ")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(address.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .disabled(address.isEmpty) // Кнопка неактивна, пока не введен адрес
        }
        .navigationTitle("Оформление")
        .alert(isPresented: $isOrderSaved) {
            Alert(
                title: Text("Успешно!"),
                message: Text("Заказ сохранен в базу SQLite."),
                dismissButton: .default(Text("ОК"))
            )
        }
    }
    
    // Логика сохранения в SQLite
    private func saveOrderToDatabase() {
        DatabaseManager.shared.saveOrder(
            id: UUID(),
            productName: product.titleLocalizationKey,
            price: product.price,
            payment: selectedPayment,
            address: address,
            comment: comment
        )
        isOrderSaved = true
    }
}
