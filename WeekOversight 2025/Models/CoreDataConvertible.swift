import Foundation
import CoreData

protocol CoreDataConvertible {
    associatedtype EntityType: NSManagedObject
    
    func toEntity(in context: NSManagedObjectContext) -> EntityType
    static func fromEntity(_ entity: EntityType) -> Self?
}

extension ClientGroup: CoreDataConvertible {
    typealias EntityType = ClientGroupEntity
    
    func toEntity(in context: NSManagedObjectContext) -> ClientGroupEntity {
        let entity = ClientGroupEntity(context: context)
        entity.id = id
        entity.name = name
        return entity
    }
    
    static func fromEntity(_ entity: ClientGroupEntity) -> ClientGroup? {
        guard let id = entity.id,
              let name = entity.name else { return nil }
        
        let weekOversights = (entity.weekOversights?.allObjects as? [WeekOversightEntity])?.compactMap(WeekOversight.fromEntity) ?? []
        return ClientGroup(id: id, name: name, weekOversights: weekOversights)
    }
}

extension WeekOversight: CoreDataConvertible {
    typealias EntityType = WeekOversightEntity
    
    func toEntity(in context: NSManagedObjectContext) -> WeekOversightEntity {
        let entity = WeekOversightEntity(context: context)
        entity.id = id
        entity.weekNumber = Int32(weekNumber)
        return entity
    }
    
    static func fromEntity(_ entity: WeekOversightEntity) -> WeekOversight? {
        guard let id = entity.id else { return nil }
        
        let dayOversights = (entity.dayOversights?.allObjects as? [DayOversightEntity])?.compactMap(DayOversight.fromEntity) ?? []
        return WeekOversight(
            id: id,
            weekNumber: Int(entity.weekNumber),
            clientGroupId: entity.clientGroup?.id ?? UUID(),
            dayOversights: dayOversights
        )
    }
}

extension DayOversight: CoreDataConvertible {
    typealias EntityType = DayOversightEntity
    
    func toEntity(in context: NSManagedObjectContext) -> DayOversightEntity {
        let entity = DayOversightEntity(context: context)
        entity.id = id
        entity.date = date
        return entity
    }
    
    static func fromEntity(_ entity: DayOversightEntity) -> DayOversight? {
        guard let id = entity.id,
              let date = entity.date else { return nil }
        
        let trucks = (entity.trucks?.allObjects as? [TruckEntity])?.compactMap(TruckData.fromEntity) ?? []
        return DayOversight(
            id: id,
            date: date,
            trucks: trucks,
            clientGroupId: entity.weekOversight?.clientGroup?.id ?? UUID(),
            weekOversightId: entity.weekOversight?.id ?? UUID()
        )
    }
}

extension TruckData: CoreDataConvertible {
    typealias EntityType = TruckEntity
    
    func toEntity(in context: NSManagedObjectContext) -> TruckEntity {
        let entity = TruckEntity(context: context)
        entity.id = id
        entity.distributionCenter = distributionCenter
        entity.boxes = Int32(boxes)
        entity.rollies = Int32(rollies)
        entity.arrivalTime = arrivalTime
        return entity
    }
    
    static func fromEntity(_ entity: TruckEntity) -> TruckData? {
        guard let id = entity.id,
              let distributionCenter = entity.distributionCenter,
              let arrivalTime = entity.arrivalTime else { return nil }
        
        return TruckData(
            id: id,
            distributionCenter: distributionCenter,
            boxes: Int(entity.boxes),
            rollies: Int(entity.rollies),
            arrivalTime: arrivalTime
        )
    }
} 