import CoreData

extension TruckEntity {
    // Add your custom methods here, but don't redefine properties
    func updateFromTruckData(_ data: TruckData) {
        self.id = data.id
        self.arrivalTime = data.arrivalTime
        self.boxes = Int32(data.boxes)
        self.rollies = Int32(data.rollies)
        self.distributionCenter = data.distributionCenter
    }
} 