//
//  TodoDetailView.swift
//  Laos_Todo
//
//  Created by YU WONGEUN on 2/14/25.
//

import SwiftUI

struct TodoDetailView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @Binding var todo: TodoItem
    
    var body: some View {
        Form {
            TextField("Title", text: $todo.title)
            DatePicker("Due Date", selection: $todo.dueDate, displayedComponents: .date)
            Toggle("Completed", isOn: $todo.isCompleted)
        }
        .navigationTitle("Edit Todo")
        .navigationBarItems(trailing: Button("Save") {
            viewModel.updateTodo(todo)
        })
    }
}


#Preview {
    TodoDetailView(viewModel: TodoListViewModel(), todo: .constant(TodoItem(title: "Sample Todo", isCompleted: true, dueDate: Date())))
}
