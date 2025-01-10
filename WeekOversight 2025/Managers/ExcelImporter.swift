import Foundation
import CoreXLSX
import AppKit

private enum ExcelSheetType {
    case trucks
    case clients
    case unknown
}

enum ExcelImportError: LocalizedError {
    case invalidFileFormat
    case fileAccessDenied
    case unsupportedWorksheet
    case missingData(String)
    case fileNotFound
    case unreadableFile(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidFileFormat:
            return "The file format is invalid. Please ensure you're using a .xlsm file."
        case .fileAccessDenied:
            return "Cannot access the file. Please check permissions."
        case .unsupportedWorksheet:
            return "The Excel file structure is not supported. Please make sure you're using the correct template."
        case .missingData(let detail):
            return "Required data is missing: \(detail)"
        case .fileNotFound:
            return "The selected file could not be found."
        case .unreadableFile(let error):
            return "Could not read the file: \(error)"
        }
    }
}

final class ExcelImporter {
    private struct ExcelColumns {
        static let boxes = ColumnReference("F")!
        static let rollies = ColumnReference("G")!
        static let distributionCenter = ColumnReference("A")!
        static let mancos = ColumnReference("K")!
    }
    
    private var debugLog = ""
    
    private func log(_ message: String) {
        debugLog += message + "\n"
        print(message)
    }
    
    @MainActor
    private func showAlert(title: String, message: String) async {
        await MainActor.run {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    private func sortSheetPaths(_ paths: [String]) -> [String] {
        return paths.sorted { path1, path2 in
            let number1 = Int(path1.replacingOccurrences(of: "xl/worksheets/sheet", with: "")
                                 .replacingOccurrences(of: ".xml", with: "")) ?? 0
            let number2 = Int(path2.replacingOccurrences(of: "xl/worksheets/sheet", with: "")
                                 .replacingOccurrences(of: ".xml", with: "")) ?? 0
            return number1 < number2
        }
    }
    
    func importExcelFile(from url: URL) async throws -> [TruckData] {
        var trucks: [TruckData] = []
        
        do {
            guard let file = try? XLSXFile(filepath: url.path) else {
                throw ExcelImportError.invalidFileFormat
            }
            
            let worksheets = try file.parseWorksheetPaths()
            
            for path in sortSheetPaths(worksheets) {
                if let worksheet = try? file.parseWorksheet(at: path) {
                    let sheetType = identifySheet(worksheet, path: path)
                    
                    if sheetType == .trucks {
                        if let truck = try parseTruckData(from: worksheet) {
                            trucks.append(truck)
                        }
                    }
                }
            }
            
            if trucks.isEmpty {
                #if DEBUG
                log("\n❌ No trucks found in any sheet")
                #endif
                throw ExcelImportError.missingData("No valid truck data sheet found")
            }
            
            log("\n✅ FINAL RESULTS:")
            log("- Found \(trucks.count) trucks")
            
            return trucks
        } catch {
            #if DEBUG
            log("\n❌ Error importing Excel file: \(error)")
            #endif
            throw error
        }
    }
    
    private func identifySheet(_ worksheet: Worksheet, path: String) -> ExcelSheetType {
        log("\n=== Identifying Sheet Type ===")
        log("Path: \(path)")
        
        // Extract sheet number from path (e.g., "sheet1.xml" -> 1)
        let sheetNumber = path.components(separatedBy: "sheet")
            .last?
            .components(separatedBy: ".")
            .first ?? ""
        
        log("Sheet number: \(sheetNumber)")
        
        // Even numbered sheets (2, 4, 6, etc) are mancos sheets
        // Odd numbered sheets (1, 3, 5, etc) are truck sheets
        if let number = Int(sheetNumber) {
            if number % 2 == 0 {
                log("✅ Even numbered sheet - identified as mancos sheet")
                return .clients
            } else {
                log("✅ Odd numbered sheet - identified as truck sheet")
                return .trucks
            }
        }
        
        log("❌ Could not determine sheet type")
        return .unknown
    }
    
    private func parseTruckData(from worksheet: Worksheet) throws -> TruckData? {
        log("\n=== Parsing Truck Data ===")
        
        let distributionCenter = try extractDistributionCenter(from: worksheet) ?? "Unknown"
        
        // Get last numeric value from column F (boxes)
        let boxes = try extractBoxCount(from: worksheet)
        log("Boxes: \(boxes)")
        
        // Get last numeric value from column G (rollies)
        let rollies = try extractRolliesCount(from: worksheet)
        log("Rollies: \(rollies)")
        
        // Create truck data
        let truck = TruckData(
            distributionCenter: distributionCenter,
            boxes: boxes,
            rollies: rollies,
            arrivalTime: Date()
        )
        
        log("\n✅ Successfully parsed truck data:")
        log("Distribution Center: \(distributionCenter)")
        log("Boxes: \(boxes)")
        log("Rollies: \(rollies)")
        
        return truck
    }
    
    private func extractMergedCellValue(from worksheet: Worksheet, column: ColumnReference) throws -> String? {
        let cells = worksheet.cells(atColumns: [column])
        return cells.last?.value.map(String.init(describing:))
    }
    
    private func extractLastNumericValue(from worksheet: Worksheet, column: ColumnReference, defaultValue: Int = 0) throws -> Int {
        log("\n📊 Extracting numeric value from column \(column)")
        let cells = worksheet.cells(atColumns: [column])
        
        // Log all numeric values found in the column
        log("All numeric values in column:")
        cells.forEach { cell in
            if let value = cell.value {
                let stringValue = String(describing: value)
                if Double(stringValue) != nil {
                    log("- Row \(cell.reference.row): \(stringValue)")
                }
            }
        }
        
        // Find the last cell that contains a numeric value
        let lastNumericCell = cells.last { cell in
            if let value = cell.value {
                let stringValue = String(describing: value)
                return Double(stringValue) != nil
            }
            return false
        }
        
        if let lastValue = lastNumericCell?.value {
            let stringValue = String(describing: lastValue)
            if let doubleValue = Double(stringValue) {
                let roundedValue = Int(round(doubleValue))
                log("✅ Found last numeric value at row \(lastNumericCell?.reference.row ?? 0): \(doubleValue) (rounded to \(roundedValue))")
                return roundedValue
            }
        }
        
        log("⚠️ No numeric value found, using default: \(defaultValue)")
        return defaultValue
    }
    
    // Move known centers to class level for reuse
    private let knownCenters = ["Beilen", "Woerden", "Breda", "Veghel"]
    
    private func extractDistributionCenter(from worksheet: Worksheet) throws -> String? {
        if let cellValue = try extractMergedCellValue(from: worksheet, column: ExcelColumns.distributionCenter) {
            return knownCenters.first { center in
                cellValue.contains(center)
            }
        }
        return nil
    }
    
    private func getCells(from worksheet: Worksheet, column: ColumnReference) -> [Cell] {
        return worksheet.cells(atColumns: [column])
    }
    
    private func extractMancosValue(from worksheet: Worksheet) throws -> Int {
        log("Extracting mancos value from column K...")
        let value = try extractLastNumericValue(from: worksheet, column: ExcelColumns.mancos)
        log("Found mancos value: \(value)")
        return value
    }
    
    private func createTruck(distributionCenter: String, arrival: Date, boxes: Int, rollies: Int) -> TruckData {
        TruckData(
            distributionCenter: distributionCenter,
            boxes: boxes,
            rollies: rollies,
            arrivalTime: arrival
        )
    }
    
    private func logTruckCreation(_ truck: TruckData) {
        log("✅ Added truck for: \(truck.distributionCenter)")
    }
    
    private func processTruckData(worksheet: Worksheet) throws -> TruckData {
        let distributionCenter = try extractDistributionCenter(from: worksheet) ?? "Unknown"
        let boxes = try extractBoxCount(from: worksheet)
        let rollies = try extractRolliesCount(from: worksheet)
        
        return TruckData(
            distributionCenter: distributionCenter,
            boxes: boxes,
            rollies: rollies,
            arrivalTime: Date()
        )
    }
    
    private func extractBoxCount(from worksheet: Worksheet) throws -> Int {
        try extractLastNumericValue(from: worksheet, column: ExcelColumns.boxes)
    }
    
    private func extractRolliesCount(from worksheet: Worksheet) throws -> Int {
        try extractLastNumericValue(from: worksheet, column: ExcelColumns.rollies)
    }
} 