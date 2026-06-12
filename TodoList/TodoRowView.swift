import SwiftUI

struct TodoRowView: View {
    var viewModel: TodoViewModel
    let todo: Todo
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                viewModel.toggleCompletion(for: todo)
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.title)
                    .font(.headline)
                    .strikethrough(todo.isCompleted, color: .gray)
                    .foregroundColor(todo.isCompleted ? .gray : .primary)
                
                HStack {
                    Label(todo.category, systemImage: "folder")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()

                    Label(todo.dueDate.formatted(.dateTime.month().day()), systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(isOverdue ? .red : .secondary)
                }
            }
            
            Spacer()

            Circle()
                .fill(todo.priority.color)
                .frame(width: 12, height: 12)
        }
        .padding(.vertical, 8)
        .opacity(todo.isCompleted ? 0.6 : 1.0)
    }
    
    private var isOverdue: Bool {
        todo.dueDate < Date() && !Calendar.current.isDateInToday(todo.dueDate) && !todo.isCompleted
    }
}
