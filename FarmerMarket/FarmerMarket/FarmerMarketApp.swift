import SwiftUI

@main
struct FarmerMarketApp: App {
    // Проверяем при старте, зарегистрирован ли пользователь
    @State private var isUserLoggedIn: Bool = AppUserManager.shared.isRegistered
    
    var body: some Scene {
        WindowGroup {
            if isUserLoggedIn {
                // Если зарегистрирован — показываем приложение с вкладками
                TabView {
                    CatalogView()
                        .tabItem {
                            Label("Каталог", systemImage: "storefront")
                        }
                    
                    OrdersHistoryView()
                        .tabItem {
                            Label("Заказы", systemImage: "clock.reveal")
                        }
                }
                .accentColor(.green) // Зеленый цвет для эко-стиля
            } else {
                // Если не зарегистрирован — принудительный экран регистрации
                RegisterView(isUserLoggedIn: $isUserLoggedIn)
            }
        }
    }
}
