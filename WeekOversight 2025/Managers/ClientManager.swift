import Foundation
import SwiftUI

@MainActor
final class ClientManager: ObservableObject {
    @Published private(set) var clientGroups: [ClientGroup] = []
    @Published var selectedClientGroup: ClientGroup?
    
    private let persistenceManager: PersistenceManager
    private let stateRestorationManager: StateRestorationManager
    private let navigationManager: NavigationManager
    private let errorHandler: ErrorHandler
    
    init(persistenceManager: PersistenceManager,
         stateRestorationManager: StateRestorationManager,
         navigationManager: NavigationManager,
         errorHandler: ErrorHandler) {
        self.persistenceManager = persistenceManager
        self.stateRestorationManager = stateRestorationManager
        self.navigationManager = navigationManager
        self.errorHandler = errorHandler
        
        Task {
            await loadClientGroups()
        }
    }
    
    private func loadClientGroups() async {
        do {
            clientGroups = try await persistenceManager.loadClientGroups()
        } catch {
            errorHandler.handle(error)
        }
    }
    
    func addClientGroup(_ group: ClientGroup) async throws {
        clientGroups.append(group)
        try await persistenceManager.saveClientGroups(clientGroups)
        try await stateRestorationManager.saveState(clientManager: self, navigationManager: navigationManager)
    }
    
    func updateClientGroup(_ group: ClientGroup) async throws {
        if let index = clientGroups.firstIndex(where: { $0.id == group.id }) {
            clientGroups[index] = group
            try await persistenceManager.saveClientGroups(clientGroups)
            try await stateRestorationManager.saveState(clientManager: self, navigationManager: navigationManager)
        }
    }
    
    func updateWeekOversight(_ oversight: WeekOversight) async throws {
        if let groupIndex = clientGroups.firstIndex(where: { $0.id == oversight.clientGroupId }),
           let oversightIndex = clientGroups[groupIndex].weekOversights.firstIndex(where: { $0.id == oversight.id }) {
            clientGroups[groupIndex].weekOversights[oversightIndex] = oversight
            try await persistenceManager.saveClientGroups(clientGroups)
            try await stateRestorationManager.saveState(clientManager: self, navigationManager: navigationManager)
        }
    }
    
    func createNewWeekOversight(for group: ClientGroup) -> WeekOversight {
        WeekOversight(
            id: UUID(),
            weekNumber: group.weekOversights.count + 1,
            clientGroupId: group.id,
            dayOversights: []
        )
    }
    
    func importOversight(_ oversight: WeekOversight) async throws {
        if let groupIndex = clientGroups.firstIndex(where: { $0.id == oversight.clientGroupId }) {
            clientGroups[groupIndex].weekOversights.append(oversight)
            try await persistenceManager.saveClientGroups(clientGroups)
            try await stateRestorationManager.saveState(clientManager: self, navigationManager: navigationManager)
        }
    }
    
    func deleteClientGroup(_ group: ClientGroup) async throws {
        var updatedGroups = clientGroups
        updatedGroups.removeAll { $0.id == group.id }
        try await persistenceManager.saveClientGroups(updatedGroups)
        clientGroups = updatedGroups
    }
} 