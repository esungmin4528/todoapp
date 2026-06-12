import Foundation
import SwiftUI

enum Priority: String, Codable, CaseIterable {
    case high = "높음"
    case medium = "보통"
    case low = "낮음"
    
    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
}

struct Todo: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var category: String
    var priority: Priority
    var dueDate: Date
    var isCompleted: Bool = false
}
