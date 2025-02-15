//
//  AddToVdoiew.swift
//  Laos_Todo
//
//  Created by YU WONGEUN on 2/14/25.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TodoListViewModel
    @State private var title = ""
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Todo Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
            .navigationTitle("Add Todo")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newTodo = TodoItem(title: title, dueDate: dueDate)
                    viewModel.addTodo(newTodo)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}


#Preview {
    AddTodoView(viewModel: TodoListViewModel())
}
