import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("userEmail") private var userEmail = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.green)
                
                Text(userName)
                    .font(.title)
                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button("Logout") {
                    showingLogoutAlert = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.top, 50)
            }
            .navigationTitle("Profile")
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
    
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        isLoggedIn = false
    }
}
