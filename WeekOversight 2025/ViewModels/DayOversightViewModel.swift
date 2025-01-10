import Foundation
import CoreData
import SwiftUI

@MainActor
class DayOversightViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private let dayOversight: DayOversightEntity
    
    @Published private(set) var trucks: [TruckData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    init(context: NSManagedObjectContext, dayOversight: DayOversightEntity) {
        self.context = context
        self.dayOversight = dayOversight
        Task { await loadTrucks() }
    }
    
    var date: Date { dayOversight.date ?? Date() }
    var id: UUID { dayOversight.id ?? UUID() }
    
    var stats: DayStats {
        DayStats(
            boxes: trucks.reduce(0) { $0 + $1.boxes },
            rollies: trucks.reduce(0) { $0 + $1.rollies }
        )
    }
    
    var groupedTrucks: [String: [TruckData]] {
        Dictionary(grouping: trucks) { $0.distributionCenter }
    }
    
    private func loadTrucks() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = NSFetchRequest<TruckEntity>(entityName: "TruckEntity")
            request.predicate = NSPredicate(format: "dayOversight == %@", dayOversight)
            request.sortDescriptors = [NSSortDescriptor(keyPath: \TruckEntity.arrivalTime, ascending: true)]
            
            let entities = try context.fetch(request)
            trucks = entities.compactMap { entity in
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
        } catch {
            self.error = error
            print("Error fetching trucks: \(error)")
        }
    }
    
    func createTruck(distributionCenter: String, arrivalTime: Date, boxes: Int, rollies: Int) async throws -> TruckData {
        let entity = TruckEntity(context: context)
        entity.id = UUID()
        entity.distributionCenter = distributionCenter
        entity.arrivalTime = arrivalTime
        entity.boxes = Int32(boxes)
        entity.rollies = Int32(rollies)
        entity.dayOversight = dayOversight
        
        if dayOversight.trucks == nil {
            dayOversight.trucks = NSSet()
        }
        dayOversight.addToTrucks(entity)
        
        try context.save()
        await loadTrucks()
        
        return TruckData(
            id: entity.id ?? UUID(),
            distributionCenter: entity.distributionCenter ?? distributionCenter,
            boxes: Int(entity.boxes),
            rollies: Int(entity.rollies),
            arrivalTime: entity.arrivalTime ?? arrivalTime
        )
    }
    
    func deleteTruck(_ truck: TruckData) async throws {
        let request = NSFetchRequest<TruckEntity>(entityName: "TruckEntity")
        request.predicate = NSPredicate(format: "id == %@", truck.id as CVarArg)
        
        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
            await loadTrucks()
        }
    }
}

// MARK: - Preview Support
extension DayOversightViewModel {
    static var preview: DayOversightViewModel {
        let context = PersistenceController.preview.container.viewContext
        let group = PreviewData.createPreviewClientGroup(in: context)
        let weekOversight = (group.weekOversights?.allObjects as? [WeekOversightEntity])?.first ?? WeekOversightEntity(context: context)
        let dayOversight = (weekOversight.dayOversights?.allObjects as? [DayOversightEntity])?.first ?? DayOversightEntity(context: context)
        return DayOversightViewModel(context: context, dayOversight: dayOversight)
    }
} 