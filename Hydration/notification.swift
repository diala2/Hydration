//
//  notification.swift
//  Hydration
//
//  Created by Diala Abdulnasser Fayoumi on 18/04/1446 AH.
import SwiftUI
import UserNotifications

struct NotificationPreferencesView: View {
    @StateObject private var viewModel = NotificationPreferencesViewModel()
    @Binding var totalWaterIntake: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notification Preferences")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("The start and end hour")
                .font(.headline)
            
            Text("Specify the start and end time to receive notifications.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                HStack(spacing: 13) {
                    hourPicker(title: "Start hour", hour: $viewModel.startHour, ampm: $viewModel.startAMPM)
                }
              
                Divider()
                HStack(spacing: 13) {
                    hourPicker(title: "End hour", hour: $viewModel.endHour, ampm: $viewModel.endAMPM)
                }
            }
            .background(Color(UIColor.systemGray6))
            .cornerRadius(9)
            
            VStack(alignment: .leading, spacing: 9) {
                Text("Notification interval")
                    .font(.headline)
                
                Text("Select how often you want to receive notifications.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 17) {
                    ForEach(0..<8) { index in
                        Button(action: {
                            viewModel.notificationInterval = index
                        }) {
                            VStack {
                                Text(viewModel.notificationIntervalLabel(for: index).components(separatedBy: " ")[0])
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.notificationInterval == index ? .white : .cyan)
                                
                                Text(viewModel.notificationIntervalLabel(for: index).components(separatedBy: " ")[1])
                                    .font(.body)
                                    .foregroundColor(viewModel.notificationInterval == index ? .white : .black)
                            }
                            .frame(width: 80, height: 70)
                            .background(viewModel.notificationInterval == index ? Color.cyan : Color(UIColor.systemGray5))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding(.top)
            
            Text(viewModel.notificationMessage)
                .foregroundColor(.green)
                .padding(.top)
            
            Spacer()
            
            // Start Button to schedule notifications
            Button(action: {
                viewModel.scheduleNotifications()
            }) {
                NavigationLink(destination: WaterIntakeView(totalWaterIntake: $totalWaterIntake)) {
                    Text("Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
                .padding(.top)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .padding()
            .navigationBarHidden(true)
        }

    private func hourPicker(title: String, hour: Binding<String>, ampm: Binding<String>) -> some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            HStack {
                TextField("HH:MM", text: hour)
                    .keyboardType(.numbersAndPunctuation)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .frame(width: 80)

                Picker("", selection: ampm) {
                    Text("AM").tag("AM")
                    Text("PM").tag("PM")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 70)
                .padding(2)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding()
    }
}


struct NotificationPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPreferencesView(totalWaterIntake: .constant(2.7))
    }
}
