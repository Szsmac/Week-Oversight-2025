import Foundation
import CoreData

extension WeekOversight {
    init(from entity: WeekOversightEntity) {
        let id = entity.id ?? UUID()
        let weekNumber = Int(entity.weekNumber)
        let clientGroupId = entity.clientGroup?.id ?? UUID()
        
        let dayOversightEntities = entity.dayOversights?.allObjects as? [DayOversightEntity] ?? []
        let dayOversights = dayOversightEntities.compactMap { dayEntity -> DayOversight? in
            guard let dayId = dayEntity.id,
                  let date = dayEntity.date else { return nil }
            
            let truckEntities = dayEntity.trucks?.allObjects as? [TruckEntity] ?? []
            let trucks = truckEntities.compactMap { truckEntity -> TruckData? in
                guard let truckId = truckEntity.id,
                      let distributionCenter = truckEntity.distributionCenter,
                      let arrivalTime = truckEntity.arrivalTime else { return nil }
                
                return TruckData(
                    id: truckId,
                    distributionCenter: distributionCenter,
                    boxes: Int(truckEntity.boxes),
                    rollies: Int(truckEntity.rollies),
                    arrivalTime: arrivalTime
                )
            }
            
            return DayOversight(
                id: dayId,
                date: date,
                trucks: trucks,
                clientGroupId: clientGroupId,
                weekOversightId: id
            )
        }
        
        self.id = id
        self.weekNumber = weekNumber
        self.clientGroupId = clientGroupId
        self.dayOversights = dayOversights
    }
} 