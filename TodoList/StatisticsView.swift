import SwiftUI
import Charts

struct StatisticsView: View {
    var viewModel: TodoViewModel
    
    let categories = ["공부", "업무", "운동", "개인", "기타"]
    
    func color(for category: String) -> Color {
        switch category {
        case "공부": return .indigo
        case "업무": return .mint
        case "운동": return .orange
        case "개인": return .yellow
        case "기타": return .purple
        default: return .gray
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    completionStatusCard
                    
                    categoryDistributionCard
                    
                    categoryDetailCard
                    
                }
                .padding()
            }
            .navigationTitle("통계")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    
    private var completionStatusCard: some View {
        let completed = viewModel.todos.filter { $0.isCompleted }.count
        let inProgress = viewModel.todos.filter { !$0.isCompleted }.count
        let total = viewModel.todos.count
        
        return VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("완료 현황")
                    .font(.title3.bold())
                Text("완료 및 미완료 비율")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if total == 0 {
                emptyChartPlaceholder
            } else {
                Chart {
                    SectorMark(angle: .value("완료", completed))
                        .foregroundStyle(Color.indigo)
                    SectorMark(angle: .value("진행중", inProgress))
                        .foregroundStyle(Color.indigo.opacity(0.15))
                }
                .frame(height: 200)
                
                HStack(spacing: 40) {
                    Spacer()
                    legendItem(color: .indigo, title: "완료", count: completed)
                    legendItem(color: .indigo.opacity(0.3), title: "진행중", count: inProgress)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
    
    private var categoryDistributionCard: some View {
        let total = viewModel.todos.count
        
        return VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("카테고리별 분포")
                    .font(.title3.bold())
                Text("카테고리별 할 일 비율")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if total == 0 {
                emptyChartPlaceholder
            } else {
                Chart(categories, id: \.self) { category in
                    let count = viewModel.todos.filter { $0.category == category }.count
                    SectorMark(
                        angle: .value("Count", count),
                        innerRadius: .ratio(0.65),
                        angularInset: 1.5
                    )
                    .foregroundStyle(color(for: category))
                }
                .frame(height: 200)
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        let count = viewModel.todos.filter { $0.category == category }.count
                        HStack {
                            Circle()
                                .fill(color(for: category))
                                .frame(width: 10, height: 10)
                            Text(category)
                                .font(.subheadline)
                            Text("\(count)개")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }

    private var categoryDetailCard: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text("카테고리 상세")
                .font(.title3.bold())
            
            ForEach(categories, id: \.self) { category in
                let categoryTodos = viewModel.todos.filter { $0.category == category }
                let total = categoryTodos.count
                let completed = categoryTodos.filter { $0.isCompleted }.count
                let progress = total == 0 ? 0.0 : Double(completed) / Double(total)
                
                VStack(spacing: 10) {
                    HStack {
                        Text(String(category.prefix(1)))
                            .font(.caption.bold())
                            .foregroundColor(color(for: category))
                            .frame(width: 30, height: 30)
                            .background(color(for: category).opacity(0.2))
                            .cornerRadius(8)
                        
                        Text(category)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(completed) / \(total)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(color(for: category).opacity(0.15))
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(color(for: category))
                                .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                
                if category != categories.last {
                    Divider()
                        .padding(.vertical, 5)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
    
    private func legendItem(color: Color, title: String, count: Int) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Circle().fill(color).frame(width: 10, height: 10)
                Text(title).font(.caption).foregroundColor(.secondary)
            }
            Text("\(count)개").font(.subheadline.bold())
        }
    }
    
    private var emptyChartPlaceholder: some View {
        Circle()
            .stroke(Color(UIColor.systemGray5), lineWidth: 40)
            .frame(height: 200)
            .overlay {
                Text("데이터 없음")
                    .foregroundColor(.secondary)
            }
            .padding(.vertical)
    }
}
