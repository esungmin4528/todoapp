import SwiftUI

struct CalendarView: View {
    var viewModel: TodoViewModel
    
    @State private var currentDate: Date = Date()
    @State private var selectedDate: Date = Date()
    
    let days = ["일", "월", "화", "수", "목", "금", "토"]
    
    // 선택된 날짜 필터링
    var selectedDatesTodos: [Todo] {
        viewModel.todos.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                calendarHeader
                    .padding()
                
                calendarGrid
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                Divider()

                todoListForSelectedDate
            }
            .navigationTitle("캘린더")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    
    private var calendarHeader: some View {
        HStack {
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text(currentDate.formatted(.dateTime.year().month()))
                .font(.title2.bold())
            
            Spacer()
            
            // 오늘로 돌아가기 버튼
            Button(action: {
                currentDate = Date()
                selectedDate = Date()
            }) {
                Text("오늘")
                    .font(.subheadline.bold())
                    .foregroundColor(.indigo)
            }
            .padding(.trailing, 10)
            
            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var calendarGrid: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        let dates = getMonthDates()
        
        return VStack(spacing: 15) {
            // 요일
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 날짜
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(0..<dates.count, id: \.self) { index in
                    if let date = dates[index] {
                        dateCell(date: date)
                    } else {
                        Text("")
                            .frame(height: 40)
                    }
                }
            }
        }
    }
    
    private func dateCell(date: Date) -> some View {
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
        let isToday = Calendar.current.isDate(date, inSameDayAs: Date())
        let hasTodo = viewModel.todos.contains { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
        
        return VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected || isToday ? .bold : .regular))
                .foregroundColor(isSelected ? .white : (isToday ? .indigo : .primary))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(isSelected ? Color.indigo : Color.clear)
                )
                .onTapGesture {
                    withAnimation {
                        selectedDate = date
                    }
                }
            
            Circle()
                .fill(hasTodo ? (isSelected ? Color.white : Color.indigo) : Color.clear)
                .frame(width: 5, height: 5)
        }
    }
    
    private var todoListForSelectedDate: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    Text(selectedDate.formatted(.dateTime.year().month().day().weekday()))
                        .font(.headline)
                    Spacer()
                    Text("\(selectedDatesTodos.count)개")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 15)
                
                if selectedDatesTodos.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "calendar.badge.minus")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("이 날짜에는 등록된 할 일이 없습니다.")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    ForEach(selectedDatesTodos) { todo in
                        TodoRowView(viewModel: viewModel, todo: todo)
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            withAnimation {
                currentDate = newDate
            }
        }
    }

    private func getMonthDates() -> [Date?] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else { return [] }
        
        let firstDayOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) // 일요일 = 1
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!.count

        var dates: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                dates.append(date)
            }
        }
        return dates
    }
}
