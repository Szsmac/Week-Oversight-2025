import Foundation

struct DayOversight: Identifiable, Codable, Hashable {
    var id: UUID
    var date: Date
    var trucks: [TruckData]
    var clientGroupId: UUID
    var weekOversightId: UUID
    
    var totalMissingBoxes: Int {
        trucks.reduce(into: 0) { $0 += $1.missingBoxes }
    }
    
    var groupedTrucks: [String: [TruckData]] {
        Dictionary(grouping: trucks) { $0.distributionCenter }
    }
    
    var stats: DayStats {
        DayStats(
            boxes: trucks.reduce(0) { $0 + $1.boxes },
            rollies: trucks.reduce(0) { $0 + $1.rollies },
            missingBoxes: trucks.reduce(0) { $0 + $1.missingBoxes }
        )
    }
    
    var totalBoxes: Int {
        trucks.reduce(0) { $0 + $1.boxes }
    }
    
    var totalRollies: Int {
        trucks.reduce(0) { $0 + $1.rollies }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
        hasher.combine(clientGroupId)
        hasher.combine(weekOversightId)
        trucks.forEach { hasher.combine($0.id) }
    }
    
    static func == (lhs: DayOversight, rhs: DayOversight) -> Bool {
        lhs.id == rhs.id &&
        lhs.date == rhs.date &&
        lhs.trucks.map { $0.id } == rhs.trucks.map { $0.id } &&
        lhs.clientGroupId == rhs.clientGroupId &&
        lhs.weekOversightId == rhs.weekOversightId
    }
} 