import Foundation

class DayOversightEditorViewModel: ObservableObject {
    @Published var editedDayOversight: DayOversight
    private let originalDayOversight: DayOversight
    
    init(dayOversight: DayOversight) {
        self.originalDayOversight = dayOversight
        self.editedDayOversight = dayOversight
    }
    
    func updateTruck(_ oldTruck: TruckData, with newTruck: TruckData) {
        if let index = editedDayOversight.trucks.firstIndex(where: { $0.id == oldTruck.id }) {
            editedDayOversight.trucks[index] = newTruck
        }
    }
    
    func deleteTrucks(at indices: IndexSet, for center: String) {
        let trucksForCenter = editedDayOversight.trucks.filter { $0.distributionCenter == center }
        indices.forEach { index in
            if let truckToDelete = trucksForCenter[safe: index],
               let globalIndex = editedDayOversight.trucks.firstIndex(where: { $0.id == truckToDelete.id }) {
                editedDayOversight.trucks.remove(at: globalIndex)
            }
        }
    }
    
    func addTruck(center: String) {
        let newTruck = TruckData(
            distributionCenter: center,
            arrival: Date(),
            boxes: 0,
            rollies: 0
        )
        editedDayOversight.trucks.append(newTruck)
    }
    
    func save() {
        // Add save logic here
        // This would typically update the parent view model or data store
    }
    
    func createNewTruck() -> TruckData {
        TruckData(
            distributionCenter: "",
            arrival: Date(),
            boxes: 0,
            rollies: 0
        )
    }
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
} 