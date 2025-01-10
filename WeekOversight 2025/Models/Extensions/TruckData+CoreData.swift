import Foundation
import CoreData

extension TruckData {
    init(from entity: TruckEntity) {
        self.init(
            id: entity.id ?? UUID(),
            distributionCenter: entity.distributionCenter ?? "Unknown",
            boxes: Int(entity.boxes),
            rollies: Int(entity.rollies),
            arrivalTime: entity.arrivalTime ?? Date()
        )
    }
} 