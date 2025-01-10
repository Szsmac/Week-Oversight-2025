import Foundation

struct DistributionCenter: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let trucks: [TruckData]
    
    var totalTrucks: Int { trucks.count }
    
    var stats: DayStats {
        DayStats(
            boxes: trucks.reduce(0) { $0 + $1.boxes },
            rollies: trucks.reduce(0) { $0 + $1.rollies }
        )
    }
    
    init(name: String, trucks: [TruckData]) {
        self.name = name
        self.trucks = trucks
    }
    
    static func == (lhs: DistributionCenter, rhs: DistributionCenter) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 