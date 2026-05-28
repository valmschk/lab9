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
}
