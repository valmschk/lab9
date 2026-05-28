import Foundation

class AppUserManager {
    static let shared = AppUserManager()
    
    private let userRegisteredKey = "isUserRegistered"
    private let userEmailKey = "userEmail"
    
    // Проверка, зарегистрирован ли пользователь
    var isRegistered: Bool {
        return UserDefaults.standard.bool(forKey: userRegisteredKey)
    }
    
    // Регистрация пользователя
    func registerUser(email: String) {
        UserDefaults.standard.set(true, forKey: userRegisteredKey)
        UserDefaults.standard.set(email, forKey: userEmailKey)
    }
    
    // Получение Email
    func getUserEmail() -> String {
        return UserDefaults.standard.string(forKey: userEmailKey) ?? ""
    }
}
