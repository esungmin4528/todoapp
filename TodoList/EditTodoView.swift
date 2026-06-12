import SwiftUI

struct EditTodoView: View {
    var viewModel: TodoViewModel
    let todo: Todo
    @Binding var showToast: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String
    @State private var category: String
    @State private var priority: Priority
    @State private var dueDate: Date
    
    // 상태 변수
    @State private var showErrorAlert = false
    @State private var showDeleteAlert = false
    
    // 카테고리 목록
    let categories = ["공부", "업무", "운동", "개인", "기타"]
    
    init(viewModel: TodoViewModel, todo: Todo, showToast: Binding<Bool>) {
        self.viewModel = viewModel
        self.todo = todo
        self._showToast = showToast
        
        _title = State(initialValue: todo.title)
        _category = State(initialValue: todo.category)
        _priority = State(initialValue: todo.priority)
        _dueDate = State(initialValue: todo.dueDate)
    }
    
    var body: some View {
        Form {
            Section(header: Text("기본 정보 수정")) {
                TextField("할 일 제목", text: $title)
                
                Picker("카테고리", selection: $category) {
                    ForEach(categories, id: \.self) { cat in
                        Text(cat).tag(cat)
                    }
                }
            }
            
            Section(header: Text("상세 설정 수정")) {
                Picker("중요도", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { p in
                        Text(p.rawValue).tag(p)
                    }
                }
                DatePicker("마감일", selection: $dueDate, displayedComponents: .date)
            }
            
            // 삭제 버튼
            Section {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Label("이 할 일 삭제하기", systemImage: "trash")
                            .bold()
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("할 일 수정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    updateAction()
                }
                .bold()
            }
        }
        .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                viewModel.deleteTodo(todo: todo)
                dismiss() // 삭제 후 메인 화면으로 복귀
            }
        } message: {
            Text("이 작업은 되돌릴 수 없습니다.")
        }
        .alert("입력 오류", isPresented: $showErrorAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("할 일 제목은 비워둘 수 없습니다.")
        }
    }
    
    private func updateAction() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        if trimmedTitle.isEmpty {
            showErrorAlert = true
            return
        }
        
        viewModel.updateTodo(todo: todo, newTitle: trimmedTitle, newCategory: category, newPriority: priority, newDueDate: dueDate)
        
        withAnimation { showToast = true }
        dismiss()
    }
}
