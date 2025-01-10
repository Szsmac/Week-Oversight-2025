import Foundation
import CoreData

extension DayOversight {
    init(from entity: DayOversightEntity) {
        self.id = entity.id ?? UUID()
        self.date = entity.date ?? Date()
        self.clientGroupId = entity.weekOversight?.clientGroup?.id ?? UUID()
        self.weekOversightId = entity.weekOversight?.id ?? UUID()
        
        let truckEntities = entity.trucks?.allObjects as? [TruckEntity] ?? []
        self.trucks = truckEntities.compactMap { truckEntity -> TruckData? in
            guard let id = truckEntity.id,
                  let distributionCenter = truckEntity.distributionCenter,
                  let arrivalTime = truckEntity.arrivalTime else { return nil }
            
            return TruckData(
                id: id,
                distributionCenter: distributionCenter,
                boxes: Int(truckEntity.boxes),
                rollies: Int(truckEntity.rollies),
                arrivalTime: arrivalTime
            )
        }
    }
} 