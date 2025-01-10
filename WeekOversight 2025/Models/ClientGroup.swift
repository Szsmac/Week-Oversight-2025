import Foundation

struct ClientGroup: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    var weekOversights: [WeekOversight]
    
    static func == (lhs: ClientGroup, rhs: ClientGroup) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.weekOversights == rhs.weekOversights
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(weekOversights)
    }
}

// MARK: - Preview Support
extension ClientGroup {
    static var preview: ClientGroup {
        ClientGroup(
            id: UUID(),
            name: "Preview Group",
            weekOversights: [.preview]
        )
    }
} 