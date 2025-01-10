import SwiftUI
import Charts

struct WeeklyStatsSummary: View {
    let weekOversight: WeekOversight
    
    private var totalStats: DayStats {
        weekOversight.dayOversights.reduce(into: DayStats(boxes: 0, rollies: 0)) { result, day in
            result = DayStats(
                boxes: result.boxes + day.stats.boxes,
                rollies: result.rollies + day.stats.rollies
            )
        }
    }
    
    var body: some View {
        List {
            Section("Weekly Totals") {
                StatRow(title: "Total Rollies", value: totalStats.rollies)
                StatRow(title: "Total Boxes", value: totalStats.boxes)
            }
            
            Section("Daily Distribution") {
                Chart(weekOversight.dayOversights) { day in
                    BarMark(
                        x: .value("Day", day.date, unit: .day),
                        y: .value("Rollies", day.stats.rollies)
                    )
                    .foregroundStyle(by: .value("Type", "Rollies"))
                    
                    BarMark(
                        x: .value("Day", day.date, unit: .day),
                        y: .value("Boxes", day.stats.boxes)
                    )
                    .foregroundStyle(by: .value("Type", "Boxes"))
                }
                .frame(height: 200)
            }
        }
        .navigationTitle("Week \(weekOversight.weekNumber) Statistics")
    }
} 