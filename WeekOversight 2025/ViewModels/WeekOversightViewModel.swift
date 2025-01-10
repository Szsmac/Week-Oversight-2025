import Foundation
import CoreData

@MainActor
final class WeekOversightViewModel: ObservableObject {
    @Published private(set) var weekOversight: WeekOversightEntity
    @Published var isLoading = false
    @Published var error: Error?
    private let context: NSManagedObjectContext
    
    var weekNumber: Int {
        Int(weekOversight.weekNumber)
    }
    
    init(context: NSManagedObjectContext, weekOversight: WeekOversightEntity) {
        self.context = context
        self.weekOversight = weekOversight
    }
    
    func dayOversight(for date: Date) -> DayOversightEntity? {
        weekOversight.dayOversights?
            .compactMap { $0 as? DayOversightEntity }
            .first { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }
    }
} 