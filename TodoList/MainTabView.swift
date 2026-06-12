import SwiftUI

struct MainTabView: View {
    @State private var viewModel = TodoViewModel()
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    var body: some View {
        TabView {
            // 홈 탭
            ContentView(viewModel: viewModel)
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
            
            // 캘린더 탭 (새로 추가됨)
            CalendarView(viewModel: viewModel)
                .tabItem {
                    Label("캘린더", systemImage: "calendar")
                }
            
            // 통계 탭
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Label("통계", systemImage: "chart.bar.fill")
                }
            
            // 설정 탭
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("설정", systemImage: "gearshape.fill")
                }
        }
        .preferredColorScheme(useSystemTheme ? nil : (isDarkMode ? .dark : .light))
    }
}
