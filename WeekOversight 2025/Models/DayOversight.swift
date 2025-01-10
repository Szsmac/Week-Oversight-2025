import Foundation

struct DayOversight: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    var trucks: [TruckData]
    let clientGroupId: UUID
    let weekOversightId: UUID
    
    var groupedTrucks: [String: [TruckData]] {
        Dictionary(grouping: trucks) { $0.distributionCenter }
    }
    
    var stats: DayStats {
        DayStats(
            boxes: trucks.reduce(0) { $0 + $1.boxes },
            rollies: trucks.reduce(0) { $0 + $1.rollies }
        )
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

// MARK: - Preview Support
extension DayOversight {
    static var preview: DayOversight {
        DayOversight(
            id: UUID(),
            date: Date(),
            trucks: [.preview],
            clientGroupId: UUID(),
            weekOversightId: UUID()
        )
    }
} 