import Foundation

@MainActor
class PersistenceManager {
    private let fileManager = FileManager.default
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private var documentsURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var clientGroupsURL: URL {
        documentsURL.appendingPathComponent("clientGroups.json")
    }
    
    func loadClientGroups() async throws -> [ClientGroup] {
        guard fileManager.fileExists(atPath: clientGroupsURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: clientGroupsURL)
        return try decoder.decode([ClientGroup].self, from: data)
    }
    
    func saveClientGroups(_ groups: [ClientGroup]) async throws {
        let data = try encoder.encode(groups)
        try data.write(to: clientGroupsURL)
    }
} 