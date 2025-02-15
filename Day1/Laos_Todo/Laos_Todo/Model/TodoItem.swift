//
//  TodoItem.swift
//  Laos_Todo
//
//  Created by YU WONGEUN on 2/14/25.
//

import Foundation

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, dueDate: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}

