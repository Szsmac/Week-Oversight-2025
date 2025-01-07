import SwiftUI
import CoreXLSX

struct ImportExcelView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    let urls: [URL]
    let onComplete: (WeekOversight) -> Void
    let currentOversight: WeekOversight?
    
    @State private var isImporting = false
    @State private var error: String?
    
    var body: some View {
        VStack(spacing: 20) {
            if isImporting {
                ProgressView("Importing Excel Files")
                    .progressViewStyle(.linear)
            } else if let error = error {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .frame(width: 300)
        .task {
            do {
                isImporting = true
                
                let securityManager = SecurityManager.shared
                guard securityManager.validateFileAccess(urls) else {
                    self.error = "Failed to access selected files"
                    return
                }
                
                defer {
                    securityManager.releaseFileAccess(urls)
                }
                
                let importer = ExcelImporter()
                var dayOversights: [DayOversight] = []
                
                for url in urls {
                    let trucks = try await importer.importExcelFile(from: url)
                    let date = extractDateFromFilename(url.lastPathComponent) ?? Date()
                    
                    dayOversights.append(DayOversight(
                        id: UUID(),
                        date: date,
                        trucks: trucks,
                        clientGroupId: clientManager.selectedClientGroup?.id ?? UUID(),
                        weekOversightId: currentOversight?.id ?? UUID()
                    ))
                }
                
                if let oversight = currentOversight {
                    var updatedOversight = oversight
                    updatedOversight.addDayOversights(dayOversights)
                    try await clientManager.updateWeekOversight(updatedOversight)
                    onComplete(updatedOversight)
                } else {
                    let weekNumber = Calendar.current.component(.weekOfYear, from: Date())
                    let newOversight = WeekOversight(
                        id: UUID(),
                        weekNumber: weekNumber,
                        clientGroupId: clientManager.selectedClientGroup?.id ?? UUID(),
                        dayOversights: dayOversights
                    )
                    
                    try await clientManager.importOversight(newOversight)
                    onComplete(newOversight)
                }
                
                dismiss()
            } catch {
                self.error = error.localizedDescription
            }
            
            isImporting = false
        }
        .interactiveDismissDisabled(isImporting)
    }
    
    private func extractDateFromFilename(_ filename: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "nl_NL")
        
        let pattern = #"(\d{2}-\d{2}-\d{4})"#
        if let range = filename.range(of: pattern, options: .regularExpression),
           let date = dateFormatter.date(from: String(filename[range])) {
            return date
        }
        return nil
    }
}

#Preview {
    ImportExcelView(urls: [], onComplete: { _ in }, currentOversight: nil)
        .withPreviewEnvironment()
}