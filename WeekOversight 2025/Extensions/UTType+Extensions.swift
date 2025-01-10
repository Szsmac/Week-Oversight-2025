import UniformTypeIdentifiers

extension UTType {
    static var excel: UTType {
        UTType(importedAs: "com.microsoft.excel")
    }
    
    static var xlsx: UTType {
        UTType(importedAs: "com.microsoft.excel.xlsx")
    }
    
    static var xlsm: UTType {
        UTType(importedAs: "com.microsoft.excel.xlsm")
    }
} 