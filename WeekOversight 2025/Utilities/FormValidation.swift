import Foundation

struct FormValidation {
    enum ValidationError: LocalizedError {
        case empty(String)
        case invalid(String)
        case tooShort(String, Int)
        case tooLong(String, Int)
        
        var errorDescription: String? {
            switch self {
            case .empty(let field):
                return "\(field) cannot be empty"
            case .invalid(let field):
                return "\(field) is invalid"
            case .tooShort(let field, let min):
                return "\(field) must be at least \(min) characters"
            case .tooLong(let field, let max):
                return "\(field) must be less than \(max) characters"
            }
        }
    }
    
    static func validateText(_ text: String, fieldName: String, minLength: Int = 1, maxLength: Int = 100) throws {
        guard !text.isEmpty else {
            throw ValidationError.empty(fieldName)
        }
        
        guard text.count >= minLength else {
            throw ValidationError.tooShort(fieldName, minLength)
        }
        
        guard text.count <= maxLength else {
            throw ValidationError.tooLong(fieldName, maxLength)
        }
    }
    
    static func validateNumber<T: Numeric & Comparable>(_ number: T, fieldName: String, min: T, max: T) throws {
        guard number >= min else {
            throw ValidationError.invalid("\(fieldName) must be at least \(min)")
        }
        
        guard number <= max else {
            throw ValidationError.invalid("\(fieldName) must be less than \(max)")
        }
    }
} 