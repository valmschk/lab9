import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var name: String = ""
    @Binding var isUserLoggedIn: Bool // Связь с главным экраном
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Регистрация")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("Добро пожаловать в сервис эко-продуктов!")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                TextField("Ваше имя", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .padding(.horizontal)
            
            Button(action: {
                if !email.isEmpty && !name.isEmpty {
                    // Сохраняем в UserDefaults через наш менеджер
                    AppUserManager.shared.registerUser(email: email)
                    // Меняем состояние, чтобы переключить экран
                    isUserLoggedIn = true
                }
            }) {
                Text("Зарегистрироваться")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(email.isEmpty || name.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .disabled(email.isEmpty || name.isEmpty)
            .padding(.horizontal)
            
            Spacer()
        }
    }
}
