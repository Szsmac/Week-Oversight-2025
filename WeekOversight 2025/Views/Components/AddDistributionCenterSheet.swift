import SwiftUI

struct AddDistributionCenterSheet: View {
    @State private var centerName = ""
    @State private var arrivalTime = Date()
    @State private var boxes = 0
    @State private var rollies = 0
    
    var onAdd: (TruckData) -> Void
    
    var body: some View {
        Form {
            TextField("Distribution Center", text: $centerName)
            DatePicker("Arrival Time", selection: $arrivalTime, displayedComponents: .hourAndMinute)
            Stepper("Boxes: \(boxes)", value: $boxes)
            Stepper("Rollies: \(rollies)", value: $rollies)
            
            Button("Add") {
                let newTruck = TruckData(
                    distributionCenter: centerName,
                    arrival: arrivalTime,
                    boxes: boxes,
                    rollies: rollies
                )
                onAdd(newTruck)
            }
            .disabled(centerName.isEmpty)
        }
        .padding()
    }
}

struct AddDistributionCenterSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddDistributionCenterSheet { truck in
            print("Added truck: \(truck.distributionCenter)")
        }
    }
} 