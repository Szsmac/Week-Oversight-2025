import Foundation

#if DEBUG
extension DayOversight {
    static var preview: DayOversight {
        DayOversight(
            id: UUID(),
            date: Date(),
            trucks: [.preview],
            clientGroupId: UUID(),
            weekOversightId: UUID()
        )
    }
}

extension WeekOversight {
    static var preview: WeekOversight {
        WeekOversight(
            id: UUID(),
            weekNumber: Calendar.current.component(.weekOfYear, from: Date()),
            clientGroupId: UUID(),
            dayOversights: [.preview]
        )
    }
}

extension ClientGroup {
    static var preview: ClientGroup {
        ClientGroup(
            id: UUID(),
            name: "Preview Group",
            weekOversights: []
        )
    }
}

extension TruckData {
    static var preview: TruckData {
        TruckData(
            id: UUID(),
            distributionCenter: "DC1",
            arrival: Date(),
            boxes: 100,
            rollies: 10
        )
    }
}
#endif 