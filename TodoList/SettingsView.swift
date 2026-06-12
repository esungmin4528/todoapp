import SwiftUI

struct SettingsView: View {
    var viewModel: TodoViewModel
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("useSystemTheme") private var useSystemTheme: Bool = true
    
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("디스플레이")) {
                    Toggle("시스템 설정 사용", isOn: $useSystemTheme)
                    
                    if !useSystemTheme {
                        Toggle("다크 모드", isOn: $isDarkMode)
                    }
                }
                
                Section(header: Text("데이터 관리")) {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Text("모든 할 일 데이터 초기화")
                    }
                }
                
                Section(header: Text("앱 정보")) {
                    HStack {
                        Text("버전")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("개발자")
                        Spacer()
                        Text("이성민")
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
            .navigationTitle("설정")
            .alert("모든 데이터 초기화", isPresented: $showResetAlert) {
                Button("취소", role: .cancel) { }
                Button("초기화", role: .destructive) {
                    withAnimation {
                        viewModel.todos.removeAll()
                    }
                }
            } message: {
                Text("저장된 모든 할 일이 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.")
            }
        }
    }
}
