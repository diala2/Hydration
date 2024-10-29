import SwiftUI

class HydrationViewModel: ObservableObject {
    @Published var bodyWeight: String = ""
    @Published var waterIntake: String = ""
    @Published var totalWaterIntake: Double = 2.7

    func calculateWaterIntake() {
        if let weight = Double(bodyWeight) {
            let waterIntakeInLiters = weight * 0.03
            self.waterIntake = String(format: "%.1f", waterIntakeInLiters)
            self.totalWaterIntake = waterIntakeInLiters // Update totalWaterIntake
        } else {
            self.waterIntake = ""
            self.totalWaterIntake = 2.7 // Default value if input is invalid
        }
    }
}
