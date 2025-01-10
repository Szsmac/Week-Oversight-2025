import Foundation
import CoreData

@MainActor
class DayOversightEditorViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private let weekOversight: WeekOversightEntity
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    init(context: NSManagedObjectContext, weekOversight: WeekOversightEntity) {
        self.context = context
        self.weekOversight = weekOversight
    }
    
    func createDayOversight(date: Date) async throws -> DayOversight {
        let entity = DayOversightEntity(context: context)
        entity.id = UUID()
        entity.date = date
        entity.weekOversight = weekOversight
        entity.trucks = NSSet()
        
        if weekOversight.dayOversights == nil {
            weekOversight.dayOversights = NSSet()
        }
        weekOversight.addToDayOversights(entity)
        
        try context.save()
        
        return DayOversight(
            id: entity.id ?? UUID(),
            date: entity.date ?? date,
            trucks: [],
            clientGroupId: weekOversight.clientGroup?.id ?? UUID(),
            weekOversightId: weekOversight.id ?? UUID()
        )
    }
}

// MARK: - Preview Support
extension DayOversightEditorViewModel {
    static var preview: DayOversightEditorViewModel {
        let context = PersistenceController.preview.container.viewContext
        let group = PreviewData.createPreviewClientGroup(in: context)
        let weekOversight = (group.weekOversights?.allObjects as? [WeekOversightEntity])?.first ?? WeekOversightEntity(context: context)
        return DayOversightEditorViewModel(context: context, weekOversight: weekOversight)
    }
} 