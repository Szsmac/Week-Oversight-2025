import Foundation

struct TruckData: Identifiable, Codable, Equatable {
    let id: UUID
    let number: String
    let boxes: Int
    let rollies: Int
    var missingBoxes: Int
    let distributionCenter: String
    let arrival: Date
    
    init(id: UUID = UUID(), 
         number: String = "",
         boxes: Int,
         rollies: Int,
         missingBoxes: Int = 0,
         distributionCenter: String,
         arrival: Date) {
        self.id = id
        self.number = number
        self.boxes = boxes
        self.rollies = rollies
        self.missingBoxes = missingBoxes
        self.distributionCenter = distributionCenter
        self.arrival = arrival
    }
    
    static func == (lhs: TruckData, rhs: TruckData) -> Bool {
        lhs.id == rhs.id &&
        lhs.number == rhs.number &&
        lhs.boxes == rhs.boxes &&
        lhs.rollies == rhs.rollies &&
        lhs.missingBoxes == rhs.missingBoxes &&
        lhs.distributionCenter == rhs.distributionCenter &&
        lhs.arrival == rhs.arrival
    }
}

extension TruckData {
    init(distributionCenter: String, arrival: Date, boxes: Int, rollies: Int, missingBoxes: Int = 0) {
        self.init(
            id: UUID(),
            number: "",
            boxes: boxes,
            rollies: rollies,
            missingBoxes: missingBoxes,
            distributionCenter: distributionCenter,
            arrival: arrival
        )
    }
}

extension TruckData {
    init(id: UUID = UUID(), 
         distributionCenter: String,
         arrival: Date,
         boxes: Int,
         rollies: Int,
         missingBoxes: Int = 0) {
        self.init(
            id: id,
            number: "",
            boxes: boxes,
            rollies: rollies,
            missingBoxes: missingBoxes,
            distributionCenter: distributionCenter,
            arrival: arrival
        )
    }
} 