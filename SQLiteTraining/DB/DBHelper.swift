//
//  DBHelper.swift
//  SQLiteTraining
//
//  Created by Achintha Kahawalage on 2022-05-20.
//

import Foundation
import SQLite3

class DBHelper{
    
    static let shared = DBHelper()
    
    var db: OpaquePointer?
    var mainList = [Model]()
    
    func openDB(){
        let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("CarsDatabase.sqlite")
        
        if sqlite3_open(fileURL?.path, &db) != SQLITE_OK{
            print("Error opening database")
        }
    }
    
    func createTable(){
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Cars (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, doors INTEGER, date DATE)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table")
        }
    }
    
    func readData() -> [Model]{
        
        let query = "SELECT * FROM Cars"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let doors = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let date = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(statement, 3))
                var model = Model()
                model.id = id
                model.name = name
                model.doors = doors
                model.date = date
                print(date)
                
                mainList.append(model)
            }
        }
        return mainList
        
    }
    
    func saveData(name: String, doors: String, date: Date){
        var statement: OpaquePointer?
        
        let insertQuery = "INSERT INTO Cars  (name, doors, date) VALUES (?, ?, ?)"
        
        if sqlite3_prepare(db, insertQuery, -1, &statement, nil) != SQLITE_OK {
            print("Error binding query")
        }
        
        if sqlite3_bind_text(statement, 1, (name as NSString).utf8String , -1, nil) != SQLITE_OK {
            print("Error binding name")
        }
        
        if sqlite3_bind_int(statement, 2, (doors as NSString).intValue) != SQLITE_OK {
            print("Error binding doors")
        }
        
        if sqlite3_bind_double(statement, 3, date.timeIntervalSinceReferenceDate) != SQLITE_OK {
            print("Error binding date")
        }
        
        if sqlite3_step(statement) == SQLITE_DONE{
            print("Car saved successfully")
        }
    }
    
    func delete(id: Int){
        let query = "DELETE FROM Cars where id = \(id)"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data delete success")
            }else {
                print("Data is not deleted in table")
            }
        }
    }
    
    func update(id : Int, name : String, doors : String) {
        let query = "UPDATE Cars SET name = '\(name)', doors = '\(doors)' where id = \(id)"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data updated success")
            }else {
                print("Data is not updated in table")
            }
        }
    }
}
