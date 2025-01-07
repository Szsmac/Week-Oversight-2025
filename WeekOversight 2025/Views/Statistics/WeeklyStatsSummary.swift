import SwiftUI
import Charts

struct WeeklyStatsSummary: View {
    let weekOversight: WeekOversight
    
    private var totalStats: TransportStats {
        weekOversight.dayOversights.reduce(into: TransportStats()) { result, day in
            let dayStats = calculateStats(for: day)
            result.boxes += dayStats.boxes
            result.rollies += dayStats.rollies
            result.missingBoxes += dayStats.missingBoxes
        }
    }
    
    private func calculateStats(for day: DayOversight) -> TransportStats {
        day.trucks.reduce(into: TransportStats()) { result, truck in
            result.boxes += truck.boxes
            result.rollies += truck.rollies
            result.missingBoxes += truck.missingBoxes
        }
    }
    
    var body: some View {
        List {
            Section("Weekly Totals") {
                StatRow(title: "Total Rollies", value: totalStats.rollies)
                StatRow(title: "Total Boxes", value: totalStats.boxes)
                StatRow(title: "Total Missing Boxes", value: totalStats.missingBoxes)
            }
            
            Section("Daily Distribution") {
                Chart(weekOversight.dayOversights) { day in
                    let stats = calculateStats(for: day)
                    BarMark(
                        x: .value("Day", day.date, unit: .day),
                        y: .value("Rollies", stats.rollies)
                    )
                    .foregroundStyle(by: .value("Type", "Rollies"))
                    
                    BarMark(
                        x: .value("Day", day.date, unit: .day),
                        y: .value("Boxes", stats.boxes)
                    )
                    .foregroundStyle(by: .value("Type", "Boxes"))
                }
                .frame(height: 200)
            }
        }
        .navigationTitle("Week \(weekOversight.weekNumber) Statistics")
    }
} 