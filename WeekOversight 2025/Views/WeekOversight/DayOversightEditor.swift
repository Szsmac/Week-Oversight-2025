import SwiftUI

struct DayOversightEditor: View {
    @Binding var editedTruck: TruckData
    
    var body: some View {
        Form {
            TextField("Distribution Center", text: Binding(
                get: { editedTruck.distributionCenter },
                set: { newValue in
                    var updated = editedTruck
                    updated = TruckData(
                        id: editedTruck.id,
                        distributionCenter: newValue,
                        arrival: editedTruck.arrival,
                        boxes: editedTruck.boxes,
                        rollies: editedTruck.rollies,
                        missingBoxes: editedTruck.missingBoxes
                    )
                    editedTruck = updated
                }
            ))
            
            DatePicker("Arrival Time", selection: Binding(
                get: { editedTruck.arrival },
                set: { newValue in
                    var updated = editedTruck
                    updated = TruckData(
                        id: editedTruck.id,
                        distributionCenter: editedTruck.distributionCenter,
                        arrival: newValue,
                        boxes: editedTruck.boxes,
                        rollies: editedTruck.rollies,
                        missingBoxes: editedTruck.missingBoxes
                    )
                    editedTruck = updated
                }
            ), displayedComponents: .hourAndMinute)
            
            // ... similar bindings for boxes, rollies, etc.
        }
        .formStyle(.grouped)
    }
} 