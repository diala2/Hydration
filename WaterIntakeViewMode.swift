//
//  WaterIntakeViewMode.swift
//  Hydration
//
//  Created by Diala Abdulnasser Fayoumi on 24/04/1446 AH.
//
import SwiftUI
import Combine

class WaterIntakeViewModel: ObservableObject {
    @Published var waterIntake: Double = 0.0
    @Binding var totalWaterIntake: Double
    @Published var hasStartedTracking: Bool = false  // Tracks if user has started tracking

    init(totalWaterIntake: Binding<Double>) {
        _totalWaterIntake = totalWaterIntake
    }

    func updateCompletionStatus() {
        if waterIntake >= totalWaterIntake {
            hasStartedTracking = false  // Reset for the next day, if needed
        }
    }
}
