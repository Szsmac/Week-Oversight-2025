import Foundation
import CoreData
import SwiftUI

@MainActor
class ClientGroupViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    
    @Published private(set) var groups: [ClientGroup] = []
    @Published private(set) var weekOversights: [WeekOversight] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        Task { await loadGroups() }
    }
    
    init(context: NSManagedObjectContext, clientGroup: ClientGroupEntity) {
        self.context = context
        Task { await loadWeekOversights(for: clientGroup) }
    }
    
    func importExcel(from url: URL) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // TODO: Implement Excel import logic
        // This is a placeholder that you'll need to implement based on your Excel format
        throw NSError(domain: "ClientGroupViewModel", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "Excel import not implemented yet"
        ])
    }
    
    private func loadGroups() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = NSFetchRequest<ClientGroupEntity>(entityName: "ClientGroupEntity")
            request.sortDescriptors = [NSSortDescriptor(keyPath: \ClientGroupEntity.name, ascending: true)]
            
            let entities = try context.fetch(request)
            groups = entities.compactMap(ClientGroup.fromEntity)
        } catch {
            self.error = error
            print("Error loading client groups: \(error)")
        }
    }
    
    private func loadWeekOversights(for clientGroup: ClientGroupEntity) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = NSFetchRequest<WeekOversightEntity>(entityName: "WeekOversightEntity")
            request.predicate = NSPredicate(format: "clientGroup == %@", clientGroup)
            request.sortDescriptors = [NSSortDescriptor(keyPath: \WeekOversightEntity.weekNumber, ascending: false)]
            
            let entities = try context.fetch(request)
            weekOversights = entities.compactMap(WeekOversight.fromEntity)
        } catch {
            self.error = error
            print("Error fetching week oversights: \(error)")
        }
    }
    
    func createWeekOversight(weekNumber: Int, for group: ClientGroup) async throws -> WeekOversight {
        let request = NSFetchRequest<ClientGroupEntity>(entityName: "ClientGroupEntity")
        request.predicate = NSPredicate(format: "id == %@", group.id as CVarArg)
        
        guard let clientGroup = try context.fetch(request).first else {
            throw NSError(domain: "ClientGroupViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Client group not found"])
        }
        
        let entity = WeekOversightEntity(context: context)
        entity.id = UUID()
        entity.weekNumber = Int32(weekNumber)
        entity.clientGroup = clientGroup
        entity.dayOversights = NSSet()
        
        // Create day oversights for the week
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        
        var dayOversights: [DayOversight] = []
        
        for dayOffset in 0..<7 {
            let dayEntity = DayOversightEntity(context: context)
            let dayId = UUID()
            dayEntity.id = dayId
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)!
            dayEntity.date = date
            dayEntity.weekOversight = entity
            dayEntity.trucks = NSSet()
            
            if entity.dayOversights == nil {
                entity.dayOversights = NSSet()
            }
            entity.addToDayOversights(dayEntity)
            
            dayOversights.append(DayOversight(
                id: dayId,
                date: date,
                trucks: [],
                clientGroupId: group.id,
                weekOversightId: entity.id ?? UUID()
            ))
        }
        
        // Add to the set of week oversights
        if clientGroup.weekOversights == nil {
            clientGroup.weekOversights = NSSet()
        }
        clientGroup.addToWeekOversights(entity)
        
        try context.save()
        await loadGroups()
        
        return WeekOversight(
            id: entity.id ?? UUID(),
            weekNumber: Int(entity.weekNumber),
            clientGroupId: group.id,
            dayOversights: dayOversights
        )
    }
}

// MARK: - Preview Support
extension ClientGroupViewModel {
    static var preview: ClientGroupViewModel {
        let context = PersistenceController.preview.container.viewContext
        let group = PreviewData.createPreviewClientGroup(in: context)
        return ClientGroupViewModel(context: context, clientGroup: group)
    }
} 