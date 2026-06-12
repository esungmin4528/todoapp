import Foundation
import SwiftUI
import Observation

@Observable
class TodoViewModel {
    var todos: [Todo] = [] {
        didSet { saveTodos() }
    }
    
    init() {
        loadTodos()
    }
    
    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: "savedTodos")
        }
    }
    
    private func loadTodos() {
        if let savedData = UserDefaults.standard.data(forKey: "savedTodos"),
           let decoded = try? JSONDecoder().decode([Todo].self, from: savedData) {
            todos = decoded
        }
    }
    
    func addTodo(title: String, category: String, priority: Priority, dueDate: Date) {
        let newTodo = Todo(title: title, category: category, priority: priority, dueDate: dueDate)
        todos.append(newTodo)
    }
    
    func updateTodo(todo: Todo, newTitle: String, newCategory: String, newPriority: Priority, newDueDate: Date) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].title = newTitle
            todos[index].category = newCategory
            todos[index].priority = newPriority
            todos[index].dueDate = newDueDate
        }
    }
    
    func toggleCompletion(for todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            withAnimation(.spring()) {
                todos[index].isCompleted.toggle()
            }
        }
    }
    
    func deleteTodo(todo: Todo) {
        todos.removeAll { $0.id == todo.id }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
    }

    var completionRate: Double {
        if todos.isEmpty { return 0.0 }
        let completedCount = todos.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(todos.count)
    }
}
