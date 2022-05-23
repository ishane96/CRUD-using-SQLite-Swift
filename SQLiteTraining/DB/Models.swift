//
//  Models.swift
//  SQLiteTraining
//
//  Created by Achintha Kahawalage on 2022-05-20.
//

import Foundation

struct Model{
    var id: Int
    var name: String
    var doors: String
    var date: Date
    
    init(id: Int? = 0, name:String? = "", doors:String? = "", date: Date? = nil){
        
        self.id = id ?? 0
        self.name = name ?? ""
        self.doors = doors ?? ""
        self.date = date ?? Date()
    }
}
