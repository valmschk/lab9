import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    
    // Таблицы
    private let products = Table("products")
    private let users = Table("users")
    private let orders = Table("orders")
    
    // Колонки для products
    private let id = Expression<Int64>("id")
    private let titleKey = Expression<String>("title_key")
    private let price = Expression<Double>("price")
    private let farmName = Expression<String>("farm_name")
    private let latitude = Expression<Double>("latitude")
    private let longitude = Expression<Double>("longitude")
    private let category = Expression<String>("category")
    
    // Колонки для users
    private let userId = Expression<Int64>("user_id")
    private let userName = Expression<String>("name")
    private let userEmail = Expression<String>("email")
    
    // Колонки для orders
    private let orderId = Expression<Int64>("order_id")
    private let orderUserId = Expression<Int64>("user_id")
    private let productsJson = Expression<String>("products_json")
    private let orderTotalPrice = Expression<Double>("total_price")
    private let orderPaymentMethod = Expression<String>("payment_method")
    private let orderAddress = Expression<String>("address")
    private let orderDate = Expression<Date>("order_date")
    
    private init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/farmers.db")
            createTables()
            seedProducts()
            print("✅ SQLite Database initialized at: \(path)/farmers.db")
        } catch {
            print("❌ Database error: \(error)")
        }
    }
    
    private func createTables() {
        do {
            try db?.run(products.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(titleKey)
                t.column(price)
                t.column(farmName)
                t.column(latitude)
                t.column(longitude)
                t.column(category)
            })
            
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(userId, primaryKey: .autoincrement)
                t.column(userName)
                t.column(userEmail, unique: true)
            })
            
            try db?.run(orders.create(ifNotExists: true) { t in
                t.column(orderId, primaryKey: .autoincrement)
                t.column(orderUserId)
                t.column(productsJson)
                t.column(orderTotalPrice)
                t.column(orderPaymentMethod)
                t.column(orderAddress)
                t.column(orderDate)
            })
            
            print("✅ Tables created successfully")
        } catch {
            print("❌ Create tables error: \(error)")
        }
    }
    
    private func seedProducts() {
        do {
            let count = try db?.scalar(products.count) ?? 0
            guard count == 0 else { return }
            
            let sampleProducts: [(String, Double, String, Double, Double, String)] = [
                ("product_milk", 3.20, "Morning Dew Farm", 53.9045, 27.5615, "dairy"),
                ("product_honey", 15.00, "Bee Paradise", 53.9080, 27.5550, "honey"),
                ("product_cheese", 8.50, "Green Valley", 53.9100, 27.5700, "dairy"),
                ("product_eggs", 4.00, "Happy Hen Farm", 53.8950, 27.5500, "eggs"),
                ("product_bread", 2.50, "Organic Bakery", 53.9200, 27.5800, "bread")
            ]
            
            for product in sampleProducts {
                let insert = products.insert(
                    titleKey <- product.0,
                    price <- product.1,
                    farmName <- product.2,
                    latitude <- product.3,
                    longitude <- product.4,
                    category <- product.5
                )
                try db?.run(insert)
            }
            print("✅ Seeded \(sampleProducts.count) products")
        } catch {
            print("❌ Seed error: \(error)")
        }
    }
    
    // MARK: - Products
    
    func fetchAllProducts() -> [FarmerProduct] {
        var result: [FarmerProduct] = []
        do {
            for product in try db!.prepare(products) {
                let fp = FarmerProduct(
                    id: UUID(),
                    titleKey: product[titleKey],
                    price: product[price],
                    farmName: product[farmName],
                    category: product[category],
                    latitude: product[latitude],
                    longitude: product[longitude]
                )
                result.append(fp)
            }
        } catch {
            print("❌ Fetch error: \(error)")
        }
        return result
    }
    
    // MARK: - Users
    
    func saveUser(name: String, email: String) -> Int64 {
        do {
            let insert = users.insert(userName <- name, userEmail <- email)
            let rowId = try db?.run(insert)
            let userId = rowId ?? 1
            
            UserDefaults.standard.set(userId, forKey: "currentUserId")
            UserDefaults.standard.set(name, forKey: "currentUserName")
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            
            print("✅ User saved: \(name) (ID: \(userId))")
            return userId
        } catch {
            print("❌ Save user error: \(error)")
            return 1
        }
    }
    
    func getCurrentUserId() -> Int64 {
        return Int64(UserDefaults.standard.integer(forKey: "currentUserId"))
    }
    
    // MARK: - Orders
    
    func saveOrder(userId: Int64, products: [CartItem], totalPrice: Double, paymentMethod: String, address: String) {
        do {
            let productsData = try JSONEncoder().encode(products)
            let productsJSON = String(data: productsData, encoding: .utf8) ?? "[]"
            
            let insert = orders.insert(
                orderUserId <- userId,
                productsJson <- productsJSON,
                orderTotalPrice <- totalPrice,
                orderPaymentMethod <- paymentMethod,
                orderAddress <- address,
                orderDate <- Date()
            )
            try db?.run(insert)
            print("✅ Order saved: \(totalPrice) BYN to \(address)")
        } catch {
            print("❌ Save order error: \(error)")
        }
    }
    
    // MARK: - Cleanup
    
    func clearAllData() {
        do {
            try db?.run(products.delete())
            try db?.run(users.delete())
            try db?.run(orders.delete())
            print("✅ All data cleared")
        } catch {
            print("❌ Clear error: \(error)")
        }
        
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.removeObject(forKey: "currentUserName")
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
    }
}
