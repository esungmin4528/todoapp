import SwiftUI

enum SortType: String, CaseIterable {
    case defaultOrder = "기본 (추가순)"
    case dueDateAsc = "마감일 임박순"
    case dueDateDesc = "마감일 여유순"
}

struct ContentView: View {
    var viewModel: TodoViewModel
    
    @State private var searchText = ""
    @State private var selectedPriorityFilter: Priority? = nil
    @State private var selectedCategoryFilter: String? = nil
    @State private var selectedSortType: SortType = .defaultOrder
    @State private var showOnlyIncomplete: Bool = false
    
    @State private var showAddSheet = false
    @State private var showFeedbackToast = false
    
    @State private var showDeleteAlert = false
    @State private var todoToDelete: Todo? = nil
    
    let categories = ["공부", "업무", "운동", "개인", "기타"]

    var filteredTodos: [Todo] {
        var result = viewModel.todos
        
        if showOnlyIncomplete {
            result = result.filter { !$0.isCompleted }
        }
        if let priority = selectedPriorityFilter {
            result = result.filter { $0.priority == priority }
        }
        if let category = selectedCategoryFilter {
            result = result.filter { $0.category == category }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.category.localizedCaseInsensitiveContains(searchText) }
        }
        
        switch selectedSortType {
        case .defaultOrder:
            break
        case .dueDateAsc:
            result.sort { $0.dueDate < $1.dueDate }
        case .dueDateDesc:
            result.sort { $0.dueDate > $1.dueDate }
        }
        
        return result
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                progressSection
                prioritySection
                categorySection
                
                if viewModel.todos.isEmpty {
                    emptyStateSection
                } else {
                    todoListSection
                }
            }
            .navigationTitle("내 할 일 관리")
            .searchable(text: $searchText, prompt: "할 일 또는 카테고리 검색")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarMenuSection
                }
            }
            .overlay(alignment: .bottomTrailing) {
                floatingAddButton
            }
            .sheet(isPresented: $showAddSheet) {
                AddTodoView(viewModel: viewModel, showToast: $showFeedbackToast)
            }
            .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
                Button("취소", role: .cancel) { }
                Button("삭제", role: .destructive) {
                    if let todo = todoToDelete {
                        withAnimation {
                            viewModel.deleteTodo(todo: todo)
                        }
                    }
                }
            } message: {
                Text("이 작업은 되돌릴 수 없습니다.")
            }
            .overlay(alignment: .top) {
                toastMessage
            }
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading) {
            Text("오늘의 달성률: \(Int(viewModel.completionRate * 100))%")
                .font(.headline)
                .foregroundStyle(.secondary)
            ProgressView(value: viewModel.completionRate)
                .tint(.green)
                .animation(.easeInOut, value: viewModel.completionRate)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 15)
    }
    
    private var prioritySection: some View {
        Picker("", selection: $selectedPriorityFilter) {
            Text("전체 보기").tag(Priority?.none)
            ForEach(Priority.allCases, id: \.self) { priority in
                Text(priority.rawValue).tag(Priority?.some(priority))
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button(action: {
                    withAnimation { selectedCategoryFilter = nil }
                }) {
                    Text("전체")
                        .font(.subheadline)
                        .fontWeight(selectedCategoryFilter == nil ? .bold : .regular)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedCategoryFilter == nil ? Color.accentColor : Color(UIColor.systemGray5))
                        .foregroundColor(selectedCategoryFilter == nil ? .white : .primary)
                        .cornerRadius(20)
                }
                
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        withAnimation { selectedCategoryFilter = category }
                    }) {
                        Text(category)
                            .font(.subheadline)
                            .fontWeight(selectedCategoryFilter == category ? .bold : .regular)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategoryFilter == category ? Color.accentColor : Color(UIColor.systemGray5))
                            .foregroundColor(selectedCategoryFilter == category ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 10)
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 15) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("등록된 할 일이 없습니다.")
                .font(.title3)
                .bold()
            Text("우측 하단의 ＋ 버튼을 눌러 할 일을 추가하세요.")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var todoListSection: some View {
            List {
                ForEach(filteredTodos) { todo in
                    NavigationLink(destination: EditTodoView(viewModel: viewModel, todo: todo, showToast: $showFeedbackToast)) {
                        TodoRowView(viewModel: viewModel, todo: todo)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            todoToDelete = todo
                            showDeleteAlert = true
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        NavigationLink(destination: EditTodoView(viewModel: viewModel, todo: todo, showToast: $showFeedbackToast)) {
                            Label("수정하기", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            todoToDelete = todo
                            showDeleteAlert = true
                        } label: {
                            Label("삭제하기", systemImage: "trash")
                        }
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        todoToDelete = filteredTodos[index]
                        showDeleteAlert = true
                    }
                }
                .onMove(perform: selectedSortType == .defaultOrder ? { source, destination in
                    viewModel.move(from: source, to: destination)
                } : nil)
            }
            .listStyle(.insetGrouped)
        }
    
    private var toolbarMenuSection: some View {
        HStack {
            Menu {
                Toggle("미완료 할 일만 보기", isOn: $showOnlyIncomplete)
                
                Divider()
                
                Picker("정렬 방식", selection: $selectedSortType) {
                    ForEach(SortType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
            
            EditButton()
        }
    }
    
    private var floatingAddButton: some View {
        Button {
            showAddSheet = true
        } label: {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
        .padding()
    }
    
    @ViewBuilder
    private var toastMessage: some View {
        if showFeedbackToast {
            Text("성공적으로 저장되었습니다.")
                .font(.subheadline)
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { showFeedbackToast = false }
                    }
                }
                .padding(.top, 20)
        }
    }
}
