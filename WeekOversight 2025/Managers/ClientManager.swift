import Foundation
import CoreData

@MainActor
class ClientManager: ObservableObject {
    @Published private(set) var clientGroups: [ClientGroup] = []
    @Published var selectedClientGroup: ClientGroup?
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        loadClientGroups()
    }
    
    func selectClientGroup(_ group: ClientGroup) {
        selectedClientGroup = group
    }
    
    func deselectClientGroup() {
        selectedClientGroup = nil
    }
    
    private func loadClientGroups() {
        let request = NSFetchRequest<ClientGroupEntity>(entityName: "ClientGroupEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ClientGroupEntity.name, ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            clientGroups = entities.compactMap { entity in
                guard let id = entity.id,
                      let name = entity.name else { return nil }
                
                let weekOversights = (entity.weekOversights?.allObjects as? [WeekOversightEntity])?.compactMap { weekEntity -> WeekOversight? in
                    guard let weekId = weekEntity.id else { return nil }
                    
                    let dayOversights = (weekEntity.dayOversights?.allObjects as? [DayOversightEntity])?.compactMap { dayEntity -> DayOversight? in
                        guard let dayId = dayEntity.id,
                              let date = dayEntity.date else { return nil }
                        
                        let trucks = (dayEntity.trucks?.allObjects as? [TruckEntity])?.compactMap { truckEntity -> TruckData? in
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
                        } ?? []
                        
                        return DayOversight(
                            id: dayId,
                            date: date,
                            trucks: trucks,
                            clientGroupId: id,
                            weekOversightId: weekId
                        )
                    } ?? []
                    
                    return WeekOversight(
                        id: weekId,
                        weekNumber: Int(weekEntity.weekNumber),
                        clientGroupId: id,
                        dayOversights: dayOversights
                    )
                } ?? []
                
                return ClientGroup(
                    id: id,
                    name: name,
                    weekOversights: weekOversights
                )
            }
        } catch {
            print("Error loading client groups: \(error)")
        }
    }
    
    func createClientGroup(name: String) async throws -> ClientGroup {
        let entity = ClientGroupEntity(context: context)
        entity.id = UUID()
        entity.name = name
        entity.weekOversights = NSSet()
        
        try context.save()
        loadClientGroups()
        
        return ClientGroup(
            id: entity.id ?? UUID(),
            name: entity.name ?? name,
            weekOversights: []
        )
    }
    
    func updateClientGroup(_ group: ClientGroup) async throws {
        let request = NSFetchRequest<ClientGroupEntity>(entityName: "ClientGroupEntity")
        request.predicate = NSPredicate(format: "id == %@", group.id as CVarArg)
        
        if let entity = try context.fetch(request).first {
            entity.name = group.name
            try context.save()
            loadClientGroups()
        }
    }
    
    func deleteClientGroup(_ group: ClientGroup) async throws {
        let request = NSFetchRequest<ClientGroupEntity>(entityName: "ClientGroupEntity")
        request.predicate = NSPredicate(format: "id == %@", group.id as CVarArg)
        
        if let entity = try context.fetch(request).first {
            context.delete(entity)
            try context.save()
            loadClientGroups()
        }
    }
    
    func updateWeekOversight(_ oversight: WeekOversight) async throws {
        let request = NSFetchRequest<WeekOversightEntity>(entityName: "WeekOversightEntity")
        request.predicate = NSPredicate(format: "id == %@", oversight.id as CVarArg)
        
        if let entity = try context.fetch(request).first {
            entity.weekNumber = Int32(oversight.weekNumber)
            try context.save()
            loadClientGroups()
        }
    }
}

extension ClientManager {
    static var preview: ClientManager {
        ClientManager(context: PersistenceController.preview.container.viewContext)
    }
} 