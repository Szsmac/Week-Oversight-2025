import Foundation
import CoreData

@MainActor
class DataMigrationManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func migrateWeekOversight(_ oversight: WeekOversight) async throws {
        let oversightEntity = WeekOversightEntity(context: context)
        oversightEntity.id = oversight.id
        oversightEntity.weekNumber = Int32(oversight.weekNumber)
        
        // Create client group if it doesn't exist
        let groupRequest = NSFetchRequest<ClientGroupEntity>(entityName: "ClientGroupEntity")
        groupRequest.predicate = NSPredicate(format: "id == %@", oversight.clientGroupId as CVarArg)
        
        let clientGroup = try context.fetch(groupRequest).first ?? {
            let group = ClientGroupEntity(context: context)
            group.id = oversight.clientGroupId
            group.name = "Imported Group"
            return group
        }()
        
        oversightEntity.clientGroup = clientGroup
        
        // Create day oversights
        for day in oversight.dayOversights {
            let dayEntity = DayOversightEntity(context: context)
            dayEntity.id = day.id
            dayEntity.date = day.date
            dayEntity.weekOversight = oversightEntity
            
            // Create trucks
            for truck in day.trucks {
                let truckEntity = TruckEntity(context: context)
                truckEntity.id = truck.id
                truckEntity.arrivalTime = truck.arrivalTime
                truckEntity.boxes = Int32(truck.boxes)
                truckEntity.rollies = Int32(truck.rollies)
                truckEntity.distributionCenter = truck.distributionCenter
                truckEntity.dayOversight = dayEntity
            }
        }
        
        try context.save()
    }
} 