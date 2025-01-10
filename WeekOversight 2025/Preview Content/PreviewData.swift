import Foundation
import CoreData
import SwiftUI

enum PreviewData {
    static func createPreviewClientGroup(in context: NSManagedObjectContext) -> ClientGroupEntity {
        let group = ClientGroupEntity(context: context)
        group.id = UUID()
        group.name = "Preview Group"
        group.weekOversights = NSSet()
        
        let weekOversight = WeekOversightEntity(context: context)
        weekOversight.id = UUID()
        weekOversight.weekNumber = 1
        weekOversight.clientGroup = group
        weekOversight.dayOversights = NSSet()
        
        group.addToWeekOversights(weekOversight)
        
        let dayOversight = DayOversightEntity(context: context)
        dayOversight.id = UUID()
        dayOversight.date = Date()
        dayOversight.weekOversight = weekOversight
        dayOversight.trucks = NSSet()
        
        weekOversight.addToDayOversights(dayOversight)
        
        let truck = TruckEntity(context: context)
        truck.id = UUID()
        truck.distributionCenter = "Distribution Center"
        truck.arrivalTime = Date()
        truck.boxes = 100
        truck.rollies = 50
        truck.dayOversight = dayOversight
        
        dayOversight.addToTrucks(truck)
        
        try? context.save()
        return group
    }
    
    static func createPreviewWeekOversight(in context: NSManagedObjectContext) -> WeekOversightEntity {
        let weekOversight = WeekOversightEntity(context: context)
        weekOversight.id = UUID()
        weekOversight.weekNumber = 1
        weekOversight.dayOversights = NSSet()
        
        let dayOversight = DayOversightEntity(context: context)
        dayOversight.id = UUID()
        dayOversight.date = Date()
        dayOversight.weekOversight = weekOversight
        dayOversight.trucks = NSSet()
        
        weekOversight.addToDayOversights(dayOversight)
        
        let truck = TruckEntity(context: context)
        truck.id = UUID()
        truck.distributionCenter = "Distribution Center"
        truck.arrivalTime = Date()
        truck.boxes = 100
        truck.rollies = 50
        truck.dayOversight = dayOversight
        
        dayOversight.addToTrucks(truck)
        
        try? context.save()
        return weekOversight
    }
    
    static func createPreviewDayOversight(in context: NSManagedObjectContext) -> DayOversightEntity {
        let dayOversight = DayOversightEntity(context: context)
        dayOversight.id = UUID()
        dayOversight.date = Date()
        dayOversight.trucks = NSSet()
        
        let truck = TruckEntity(context: context)
        truck.id = UUID()
        truck.distributionCenter = "Distribution Center"
        truck.arrivalTime = Date()
        truck.boxes = 100
        truck.rollies = 50
        truck.dayOversight = dayOversight
        
        dayOversight.addToTrucks(truck)
        
        try? context.save()
        return dayOversight
    }
} 