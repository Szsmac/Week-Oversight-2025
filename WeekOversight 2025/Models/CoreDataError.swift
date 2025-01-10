import Foundation

enum CoreDataError: LocalizedError {
    case entityNotFound
    case saveFailed(Error)
    case fetchFailed(Error)
    case deleteFailed(Error)
    case invalidEntityType
    
    var errorDescription: String? {
        switch self {
        case .entityNotFound:
            "The requested entity could not be found"
        case .saveFailed(let error):
            "Failed to save changes: \(error.localizedDescription)"
        case .fetchFailed(let error):
            "Failed to fetch data: \(error.localizedDescription)"
        case .deleteFailed(let error):
            "Failed to delete entity: \(error.localizedDescription)"
        case .invalidEntityType:
            "Invalid entity type"
        }
    }
} 