import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {
        openDatabase()
        createTables()
    }
    
    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("FarmerMarket.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Ошибка открытия базы данных SQLite")
        }
    }
    
    private func createTables() {
        // Таблица для хранения заказов
        let createOrderTableQuery = """
        CREATE TABLE IF NOT EXISTS Orders (
            id TEXT PRIMARY KEY,
            product_name TEXT,
            price REAL,
            payment_method TEXT,
            address TEXT,
            comment TEXT
        );
        """
        
        if sqlite3_exec(db, createOrderTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Ошибка создания таблицы заказов")
        }
    }
    
    // Метод сохранения заказа
    func saveOrder(id: UUID, productName: String, price: Double, payment: String, address: String, comment: String) {
        let insertQuery = "INSERT INTO Orders (id, product_name, price, payment_method, address, comment) VALUES (?, ?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (id.uuidString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (productName as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 3, price)
            sqlite3_bind_text(statement, 4, (payment as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (comment as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Заказ успешно сохранен в SQLite!")
            } else {
                print("Не удалось сохранить заказ")
            }
        }
        sqlite3_finalize(statement)
    }
    // Метод для загрузки всех заказов из SQLite
    func fetchOrders() -> [[String: Any]] {
        let query = "SELECT * FROM Orders;"
        var statement: OpaquePointer?
        var result: [[String: Any]] = []
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = String(cString: sqlite3_column_text(statement, 0))
                let productName = String(cString: sqlite3_column_text(statement, 1))
                let price = sqlite3_column_double(statement, 2)
                let payment = String(cString: sqlite3_column_text(statement, 3))
                let address = String(cString: sqlite3_column_text(statement, 4))
                let comment = String(cString: sqlite3_column_text(statement, 5))
                
                let order: [String: Any] = [
                    "id": id,
                    "product_name": productName,
                    "price": price,
                    "payment_method": payment,
                    "address": address,
                    "comment": comment
                ]
                result.append(order)
            }
        }
        sqlite3_finalize(statement)
        return result
    }

}
