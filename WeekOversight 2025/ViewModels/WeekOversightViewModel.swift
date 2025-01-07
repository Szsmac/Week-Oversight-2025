import Foundation

class WeekOversightViewModel: ObservableObject {
    @Published var currentWeek: WeekOversight
    @Published var selectedDay: Date?
    @Published var selectedTrucks: [TruckData]?
    
    init(weekOversight: WeekOversight? = nil) {
        if let weekOversight = weekOversight {
            self.currentWeek = weekOversight
        } else {
            // Initialize with default week oversight
            self.currentWeek = WeekOversight(
                id: UUID(),
                weekNumber: Calendar.current.component(.weekOfYear, from: Date()),
                clientGroupId: UUID(),
                dayOversights: []
            )
        }
    }
    
    func trucksForDay(_ date: Date) -> [TruckData] {
        currentWeek.dayOversights
            .first { Calendar.current.isDate($0.date, inSameDayAs: date) }?
            .trucks ?? []
    }
}

struct Week {
    let date: Date
    // Add any other week-related properties you need
    
    init(date: Date) {
        self.date = date
    }
} 