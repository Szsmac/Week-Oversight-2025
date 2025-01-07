import Foundation

struct DistributionCenter: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let trucks: [TruckData]
    
    var totalTrucks: Int { trucks.count }
    var totalBoxes: Int { trucks.reduce(0) { $0 + $1.boxes } }
    var totalRollies: Int { trucks.reduce(0) { $0 + $1.rollies } }
    
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