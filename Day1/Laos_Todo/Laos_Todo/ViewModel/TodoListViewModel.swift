//
//  TodoListViewModel.swift
//  Laos_Todo
//
//  Created by YU WONGEUN on 2/14/25.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    
    init() {
        loadTodos()
    }
    
    func addTodo(_ todo: TodoItem) {
        todos.append(todo)
        saveTodos()
    }
    
    func updateTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            saveTodos()
        }
    }
    
    func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: "todos")
        }
    }
    
    private func loadTodos() {
        if let savedTodos = UserDefaults.standard.data(forKey: "todos") {
            if let decodedTodos = try? JSONDecoder().decode([TodoItem].self, from: savedTodos) {
                todos = decodedTodos
            }
        }
    }
}
