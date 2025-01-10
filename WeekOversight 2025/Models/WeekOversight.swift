import Foundation

struct WeekOversight: Identifiable, Codable, Hashable {
    let id: UUID
    let weekNumber: Int
    let clientGroupId: UUID
    var dayOversights: [DayOversight]
    
    var date: Date {
        dayOversights.first?.date ?? Date()
    }
    
    var totalTrucks: Int {
        dayOversights.reduce(0) { $0 + $1.trucks.count }
    }
    
    var totalBoxes: Int {
        dayOversights.reduce(0) { $0 + $1.stats.boxes }
    }
    
    var totalRollies: Int {
        dayOversights.reduce(0) { $0 + $1.stats.rollies }
    }
    
    static func == (lhs: WeekOversight, rhs: WeekOversight) -> Bool {
        lhs.id == rhs.id &&
        lhs.weekNumber == rhs.weekNumber &&
        lhs.clientGroupId == rhs.clientGroupId &&
        lhs.dayOversights == rhs.dayOversights
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(weekNumber)
        hasher.combine(clientGroupId)
        hasher.combine(dayOversights)
    }
}

// MARK: - Preview Support
extension WeekOversight {
    static var preview: WeekOversight {
        WeekOversight(
            id: UUID(),
            weekNumber: 1,
            clientGroupId: UUID(),
            dayOversights: [.preview]
        )
    }
} 