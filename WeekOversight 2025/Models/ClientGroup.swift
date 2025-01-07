import Foundation

struct ClientGroup: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    var weekOversights: [WeekOversight]
    
    var lastUpdated: Date? {
        weekOversights
            .sorted { $0.date > $1.date }
            .first?.date
    }
    
    init(id: UUID = UUID(), name: String, weekOversights: [WeekOversight] = []) {
        self.id = id
        self.name = name
        self.weekOversights = weekOversights
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ClientGroup, rhs: ClientGroup) -> Bool {
        lhs.id == rhs.id
    }
} 