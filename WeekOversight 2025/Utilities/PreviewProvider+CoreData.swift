import CoreData
import SwiftUI

extension PreviewProvider {
    static var previewContext: NSManagedObjectContext {
        PersistenceController.preview.container.viewContext
    }
    
    static func createPreviewClientGroup(in context: NSManagedObjectContext = previewContext) -> ClientGroupEntity {
        let clientGroup = ClientGroupEntity(context: context)
        clientGroup.id = UUID()
        clientGroup.name = "Sample Group"
        
        let weekOversight = WeekOversightEntity(context: context)
        weekOversight.id = UUID()
        weekOversight.weekNumber = 1
        weekOversight.clientGroup = clientGroup
        
        // Initialize the weekOversights set if needed
        if clientGroup.weekOversights == nil {
            clientGroup.weekOversights = NSSet()
        }
        clientGroup.addToWeekOversights(weekOversight)
        
        let dayOversight = DayOversightEntity(context: context)
        dayOversight.id = UUID()
        dayOversight.date = Date()
        dayOversight.weekOversight = weekOversight
        
        // Initialize the dayOversights set if needed
        if weekOversight.dayOversights == nil {
            weekOversight.dayOversights = NSSet()
        }
        weekOversight.addToDayOversights(dayOversight)
        
        let truck = TruckEntity(context: context)
        truck.id = UUID()
        truck.arrivalTime = Date()
        truck.boxes = 100
        truck.rollies = 50
        truck.distributionCenter = "Center A"
        truck.dayOversight = dayOversight
        
        // Initialize the trucks set if needed
        if dayOversight.trucks == nil {
            dayOversight.trucks = NSSet()
        }
        dayOversight.addToTrucks(truck)
        
        try? context.save()
        return clientGroup
    }
}

extension NSManagedObjectContext {
    func createPreviewData() {
        let clientGroup = ClientGroupEntity(context: self)
        clientGroup.id = UUID()
        clientGroup.name = "Sample Group"
        clientGroup.weekOversights = NSSet()
        
        let weekOversight = WeekOversightEntity(context: self)
        weekOversight.id = UUID()
        weekOversight.weekNumber = 1
        weekOversight.clientGroup = clientGroup
        weekOversight.dayOversights = NSSet()
        
        clientGroup.addToWeekOversights(weekOversight)
        
        let dayOversight = DayOversightEntity(context: self)
        dayOversight.id = UUID()
        dayOversight.date = Date()
        dayOversight.weekOversight = weekOversight
        dayOversight.trucks = NSSet()
        
        weekOversight.addToDayOversights(dayOversight)
        
        let truck = TruckEntity(context: self)
        truck.id = UUID()
        truck.arrivalTime = Date()
        truck.boxes = 100
        truck.rollies = 50
        truck.distributionCenter = "Center A"
        truck.dayOversight = dayOversight
        
        dayOversight.addToTrucks(truck)
        
        try? save()
    }
} 