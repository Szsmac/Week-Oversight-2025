import Foundation
import CoreData

@MainActor
class CoreDataManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createWeekOversight(weekNumber: Int, clientGroup: ClientGroupEntity) async throws -> WeekOversightEntity {
        let entity = WeekOversightEntity(context: context)
        entity.id = UUID()
        entity.weekNumber = Int32(weekNumber)
        entity.clientGroup = clientGroup
        entity.dayOversights = NSSet()
        
        // Create day oversights for the week
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        
        for dayOffset in 0..<7 {
            let dayEntity = DayOversightEntity(context: context)
            dayEntity.id = UUID()
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)!
            dayEntity.date = date
            dayEntity.weekOversight = entity
            dayEntity.trucks = NSSet()
            
            entity.addToDayOversights(dayEntity)
        }
        
        try context.save()
        return entity
    }
    
    func createDayOversight(date: Date, weekOversight: WeekOversightEntity) async throws -> DayOversightEntity {
        let entity = DayOversightEntity(context: context)
        entity.id = UUID()
        entity.date = date
        entity.weekOversight = weekOversight
        entity.trucks = NSSet()
        
        try context.save()
        return entity
    }
    
    func createTruck(distributionCenter: String, arrivalTime: Date, boxes: Int, rollies: Int, dayOversight: DayOversightEntity) async throws -> TruckEntity {
        let entity = TruckEntity(context: context)
        entity.id = UUID()
        entity.distributionCenter = distributionCenter
        entity.arrivalTime = arrivalTime
        entity.boxes = Int32(boxes)
        entity.rollies = Int32(rollies)
        entity.dayOversight = dayOversight
        
        try context.save()
        return entity
    }
    
    func delete(_ object: NSManagedObject) async throws {
        context.delete(object)
        try context.save()
    }
}

extension CoreDataManager {
    static var preview: CoreDataManager {
        CoreDataManager(context: PersistenceController.preview.container.viewContext)
    }
} 