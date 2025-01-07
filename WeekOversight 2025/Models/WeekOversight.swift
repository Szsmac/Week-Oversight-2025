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
        dayOversights.reduce(0) { $0 + $1.trucks.reduce(0) { $0 + $1.boxes } }
    }
    
    var totalRollies: Int {
        dayOversights.reduce(0) { $0 + $1.trucks.reduce(0) { $0 + $1.rollies } }
    }
    
    mutating func addDayOversights(_ newDays: [DayOversight]) {
        var updatedDays = newDays
        for i in 0..<updatedDays.count {
            var day = updatedDays[i]
            day.clientGroupId = clientGroupId
            day.weekOversightId = id
            updatedDays[i] = day
        }
        dayOversights.append(contentsOf: updatedDays)
    }
    
    static func == (lhs: WeekOversight, rhs: WeekOversight) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 