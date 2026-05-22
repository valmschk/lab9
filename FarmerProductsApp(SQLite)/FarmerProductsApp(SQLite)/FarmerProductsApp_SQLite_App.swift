import SwiftUI

@main
struct FarmerProductsApp: App {
    @StateObject private var cartVM = CartViewModel()
    
    var body: some Scene {
        WindowGroup {
            RegistrationView()
                .environmentObject(cartVM)
        }
    }
}
    