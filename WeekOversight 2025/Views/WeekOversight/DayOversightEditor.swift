import SwiftUI

struct DayOversightEditor: View {
    @Binding var editedTruck: TruckData
    
    var body: some View {
        Form {
            TextField("Distribution Center", text: Binding(
                get: { editedTruck.distributionCenter },
                set: { newValue in
                    editedTruck = TruckData(
                        id: editedTruck.id,
                        distributionCenter: newValue,
                        boxes: editedTruck.boxes,
                        rollies: editedTruck.rollies,
                        arrivalTime: editedTruck.arrivalTime
                    )
                }
            ))
            
            DatePicker("Arrival Time", selection: Binding(
                get: { editedTruck.arrivalTime },
                set: { newValue in
                    editedTruck = TruckData(
                        id: editedTruck.id,
                        distributionCenter: editedTruck.distributionCenter,
                        boxes: editedTruck.boxes,
                        rollies: editedTruck.rollies,
                        arrivalTime: newValue
                    )
                }
            ), displayedComponents: .hourAndMinute)
            
            Stepper("Boxes: \(editedTruck.boxes)", value: Binding(
                get: { editedTruck.boxes },
                set: { newValue in
                    editedTruck = TruckData(
                        id: editedTruck.id,
                        distributionCenter: editedTruck.distributionCenter,
                        boxes: newValue,
                        rollies: editedTruck.rollies,
                        arrivalTime: editedTruck.arrivalTime
                    )
                }
            ))
            
            Stepper("Rollies: \(editedTruck.rollies)", value: Binding(
                get: { editedTruck.rollies },
                set: { newValue in
                    editedTruck = TruckData(
                        id: editedTruck.id,
                        distributionCenter: editedTruck.distributionCenter,
                        boxes: editedTruck.boxes,
                        rollies: newValue,
                        arrivalTime: editedTruck.arrivalTime
                    )
                }
            ))
        }
        .formStyle(.grouped)
    }
}

#Preview {
    @Previewable @State var truck = TruckData(
        distributionCenter: "Test Center",
        boxes: 100,
        rollies: 50,
        arrivalTime: Date()
    )
    
    return DayOversightEditor(editedTruck: $truck)
} 