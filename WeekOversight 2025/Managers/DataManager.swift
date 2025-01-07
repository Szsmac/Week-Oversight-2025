import Foundation

class DataManager {
    static let shared = DataManager()
    private let clientGroupsKey = "clientGroups"
    private let weekOversightsKey = "weekOversights"
    
    // Client Groups
    func saveClientGroups(_ groups: [ClientGroup]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(groups)
            UserDefaults.standard.set(data, forKey: clientGroupsKey)
        } catch {
            print("Error saving client groups: \(error)")
        }
    }
    
    func loadClientGroups() -> [ClientGroup] {
        guard let data = UserDefaults.standard.data(forKey: clientGroupsKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([ClientGroup].self, from: data)
        } catch {
            print("Error loading client groups: \(error)")
            return []
        }
    }
    
    // Week Oversights
    func saveWeekOversight(_ oversight: WeekOversight) {
        var oversights = loadWeekOversights()
        if let index = oversights.firstIndex(where: { $0.id == oversight.id }) {
            oversights[index] = oversight
        } else {
            oversights.append(oversight)
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(oversights)
            UserDefaults.standard.set(data, forKey: weekOversightsKey)
        } catch {
            print("Error saving week oversight: \(error)")
        }
    }
    
    func loadWeekOversights() -> [WeekOversight] {
        guard let data = UserDefaults.standard.data(forKey: weekOversightsKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([WeekOversight].self, from: data)
        } catch {
            print("Error loading week oversights: \(error)")
            return []
        }
    }
} 