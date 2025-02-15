//
//  ContentView.swift
//  Laos_Todo
//
//  Created by YU WONGEUN on 2/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var showingAddTodo = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.todos) { $todo in
                    NavigationLink(destination: TodoDetailView(viewModel: viewModel, todo: $todo)) {
                        TodoRowView(todo: todo)
                    }
                }
                .onDelete(perform: viewModel.deleteTodo)
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTodo = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(viewModel: viewModel)
            }
        }
    }
}

struct TodoRowView: View {
    let todo: TodoItem
    
    var body: some View {
        HStack {
            Text(todo.title)
            Spacer()
            if todo.isCompleted {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
        }
    }
}


#Preview {
    ContentView()
}
