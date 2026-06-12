import SwiftUI

struct AddTodoView: View {
    var viewModel: TodoViewModel
    @Binding var showToast: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var category: String = "공부" // 기본 선택값
    @State private var priority: Priority = .medium
    @State private var dueDate: Date = Date()
    
    @State private var showErrorAlert = false
    
    // 카테고리 목록
    let categories = ["공부", "업무", "운동", "개인", "기타"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("기본 정보")) {
                    TextField("할 일 제목을 입력하세요", text: $title)
                    
                    Picker("카테고리", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
                
                Section(header: Text("상세 설정")) {
                    Picker("중요도 설정", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    DatePicker("마감일 선택", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("새 할 일 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        saveAction()
                    }
                    .bold()
                }
            }
            .alert("입력 오류", isPresented: $showErrorAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text("할 일 제목을 반드시 입력해야 합니다.")
            }
        }
    }
    
    private func saveAction() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        if trimmedTitle.isEmpty {
            showErrorAlert = true
            return
        }
        
        viewModel.addTodo(title: trimmedTitle, category: category, priority: priority, dueDate: dueDate)
        
        withAnimation { showToast = true }
        dismiss()
    }
}
