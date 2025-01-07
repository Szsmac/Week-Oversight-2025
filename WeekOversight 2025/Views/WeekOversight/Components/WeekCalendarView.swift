import SwiftUI
import Foundation

struct WeekCalendarView: View {
    @Binding var selectedDate: Date?
    let weekOversight: WeekOversight
    
    private let weekdays = Calendar.current.shortWeekdaySymbols
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 12) {
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Days grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInWeek, id: \.self) { date in
                    DayCell(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate ?? Date()),
                        hasOversight: weekOversight.dayOversights.contains { calendar.isDate($0.date, inSameDayAs: date) }
                    )
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var daysInWeek: [Date] {
        guard let firstDay = weekOversight.dayOversights.first?.date else { return [] }
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstDay))!
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: startOfWeek)! }
    }
}

private struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasOversight: Bool
    
    var body: some View {
        Text(date.formatted(.dateTime.day()))
            .font(.callout)
            .frame(height: 32)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .blue
        } else if hasOversight {
            return Color(nsColor: .selectedControlColor)
        } else {
            return Color(nsColor: .controlBackgroundColor)
        }
    }
} 