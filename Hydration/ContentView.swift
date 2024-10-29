////  ContentView.swift
//  Hydration
//
//  Created by Diala Abdulnasser Fayoumi on 17/04/1446 AH.
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HydrationViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color.cyan)
                    
                    Text("Hydrate")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Start with Hydrate to re  cord and track your water intake daily based on your needs and stay hydrated")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        TextField("Body weight ", text: $viewModel.bodyWeight)
                            .font(.body)
                            .keyboardType(.decimalPad)
                            .padding(12)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(4)
                            .padding(.top, 8)
                         
                            .onChange(of: viewModel.bodyWeight) { _ in
                                viewModel.calculateWaterIntake()
                            }
                        
                      
                          
                    }
                   
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                if !viewModel.waterIntake.isEmpty {
                    Text("Recommended Water Intake: \(viewModel.waterIntake) liters per day")
                        .font(.body)
                        .padding(.top, 16)
                }
                
                NavigationLink(destination: NotificationPreferencesView(totalWaterIntake: $viewModel.totalWaterIntake)) {
                    Text("Next")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                .disabled(viewModel.bodyWeight.isEmpty) // Disable if body weight is not entered
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
