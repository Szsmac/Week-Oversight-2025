import Foundation
import SwiftUI

@MainActor
final class ClientManager: ObservableObject {
    @Published var selectedClientGroup: ClientGroup?
    @Published var clientGroups: [ClientGroup] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let persistenceManager: PersistenceManager
    private let stateRestorationManager: StateRestorationManager
    private let navigationManager: NavigationManager
    private let errorHandler: ErrorHandler
    
    init(
        persistenceManager: PersistenceManager,
        stateRestorationManager: StateRestorationManager,
        navigationManager: NavigationManager,
        errorHandler: ErrorHandler
    ) {
        self.persistenceManager = persistenceManager
        self.stateRestorationManager = stateRestorationManager
        self.navigationManager = navigationManager
        self.errorHandler = errorHandler
    }
    
    func loadClientGroups() async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let groups: [ClientGroup] = try await persistenceManager.load(filename: "clientGroups")
            withAnimation(AppAnimation.standard) {
                clientGroups = groups
            }
        } catch {
            errorHandler.handle(error)
            throw error
        }
    }
    
    func addClientGroup(_ group: ClientGroup) async throws {
        clientGroups.append(group)
        try await saveClientGroups()
    }
    
    func updateClientGroup(_ group: ClientGroup) async throws {
        guard let index = clientGroups.firstIndex(where: { $0.id == group.id }) else {
            return
        }
        
        withAnimation(AppAnimation.standard) {
            clientGroups[index] = group
        }
        
        try await saveClientGroups()
    }
    
    func deleteClientGroup(_ group: ClientGroup) async throws {
        withAnimation(AppAnimation.standard) {
            clientGroups.removeAll { $0.id == group.id }
        }
        
        try await saveClientGroups()
    }
    
    private func saveClientGroups() async throws {
        try await persistenceManager.save(clientGroups, filename: "clientGroups")
    }
    
    func createNewWeekOversight(for group: ClientGroup) -> WeekOversight {
        let weekNumber = Calendar.current.component(.weekOfYear, from: Date())
        let days = (1...7).map { dayNumber in
            DayOversight(
                id: UUID(),
                date: Calendar.current.date(byAdding: .day, value: dayNumber - 1, to: Date()) ?? Date(),
                trucks: [],
                clientGroupId: group.id,
                weekOversightId: UUID()
            )
        }
        
        return WeekOversight(
            id: UUID(),
            weekNumber: weekNumber,
            clientGroupId: group.id,
            dayOversights: days
        )
    }
    
    func updateWeekOversight(_ oversight: WeekOversight) async throws {
        guard let groupIndex = clientGroups.firstIndex(where: { $0.id == oversight.clientGroupId }),
              let oversightIndex = clientGroups[groupIndex].weekOversights.firstIndex(where: { $0.id == oversight.id }) else {
            return
        }
        
        withAnimation(AppAnimation.standard) {
            clientGroups[groupIndex].weekOversights[oversightIndex] = oversight
        }
        
        try await saveClientGroups()
    }
    
    func importOversight(_ oversight: WeekOversight) async throws {
        guard let groupIndex = clientGroups.firstIndex(where: { $0.id == oversight.clientGroupId }) else {
            return
        }
        
        withAnimation(AppAnimation.standard) {
            clientGroups[groupIndex].weekOversights.append(oversight)
        }
        
        try await saveClientGroups()
    }
} 