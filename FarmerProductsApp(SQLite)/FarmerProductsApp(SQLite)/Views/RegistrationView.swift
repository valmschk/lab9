import SwiftUI

struct RegistrationView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var isRegistered = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userName") private var savedName = ""
    @AppStorage("userEmail") private var savedEmail = ""
    
    var body: some View {
        if isLoggedIn {
            MainTabView()
        } else {
            registrationForm
        }
    }
    
    var registrationForm: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Farmer Products")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.name)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                
                Button("Register") {
                    register()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || email.isEmpty)
            }
            .padding()
            .navigationTitle("Registration")
        }
    }
    
    private func register() {
        let userId = DatabaseManager.shared.saveUser(name: name, email: email)
        UserDefaults.standard.set(userId, forKey: "userId")
        
        savedName = name
        savedEmail = email
        isLoggedIn = true
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label("Catalog", systemImage: "list.bullet")
                }
            
            FarmMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
