import Foundation

@MainActor
class PersistenceManager {
    enum PersistenceError: LocalizedError {
        case saveError(String)
        case loadError(String)
        case deleteError(String)
        
        var errorDescription: String? {
            switch self {
            case .saveError(let details): return "Failed to save: \(details)"
            case .loadError(let details): return "Failed to load: \(details)"
            case .deleteError(let details): return "Failed to delete: \(details)"
            }
        }
    }
    
    private let fileManager = FileManager.default
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func fileURL(for filename: String) -> URL {
        documentsDirectory.appendingPathComponent(filename).appendingPathExtension("json")
    }
    
    func save<T: Encodable>(_ item: T, filename: String) async throws {
        do {
            let data = try encoder.encode(item)
            let url = fileURL(for: filename)
            try data.write(to: url)
        } catch {
            throw PersistenceError.saveError(error.localizedDescription)
        }
    }
    
    func load<T: Decodable>(filename: String) async throws -> T {
        do {
            let url = fileURL(for: filename)
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw PersistenceError.loadError(error.localizedDescription)
        }
    }
    
    func delete(filename: String) async throws {
        do {
            let url = fileURL(for: filename)
            try fileManager.removeItem(at: url)
        } catch {
            throw PersistenceError.deleteError(error.localizedDescription)
        }
    }
} 