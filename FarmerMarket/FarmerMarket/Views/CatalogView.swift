import SwiftUI

struct CatalogView: View {
    
    @StateObject private var viewModel = CatalogViewModel()
    @State private var isShowingMap = false // Состояние для открытия карты
    
    var body: some View {
        NavigationView {
            List(viewModel.products) { product in
                // NavigationLink делает элементы списка кликабельными и ведет на OrderView
                NavigationLink(destination: OrderView(product: product)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(LocalizedStringKey(product.titleLocalizationKey))
                                .font(.headline)
                            
                            Text(product.farmName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text(String(format: "%.2f BYN", product.price))
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(LocalizedStringKey("catalog_title_key"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingMap = true // Открываем карту по нажатию
                    }) {
                        Image(systemName: "map") // Заменили иконку на карту для наглядности
                    }
                }
            }
            // Лист, который выдвигается снизу при нажатии на кнопку карты
            .sheet(isPresented: $isShowingMap) {
                NavigationView {
                    MarketMapView()
                }
            }
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}
