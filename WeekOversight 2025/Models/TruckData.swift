import Foundation

struct TruckData: Identifiable, Codable, Hashable {
    let id: UUID
    let distributionCenter: String
    let boxes: Int
    let rollies: Int
    let arrivalTime: Date
    
    init(id: UUID = UUID(), distributionCenter: String, boxes: Int, rollies: Int, arrivalTime: Date) {
        self.id = id
        self.distributionCenter = distributionCenter
        self.boxes = boxes
        self.rollies = rollies
        self.arrivalTime = arrivalTime
    }
    
    static let preview = TruckData(
        distributionCenter: "DC1",
        boxes: 100,
        rollies: 50,
        arrivalTime: Date()
    )
} 