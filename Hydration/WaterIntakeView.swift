import SwiftUI
struct WaterIntakeView: View {
    @StateObject private var viewModel: WaterIntakeViewModel

    init(totalWaterIntake: Binding<Double>) {
        _viewModel = StateObject(wrappedValue: WaterIntakeViewModel(totalWaterIntake: totalWaterIntake))
    }

    var body: some View {
        ZStack {
            // Main water intake tracking page
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Today's Water Intake")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)

                    Text("\(viewModel.waterIntake, specifier: "%.1f") liter / \(viewModel.totalWaterIntake, specifier: "%.1f") liter")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.top, 10)
                .padding(.leading, 16)

                Spacer()

                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .foregroundColor(Color.gray.opacity(0.1))

                    Circle()
                        .trim(from: 0, to: min(viewModel.waterIntake / viewModel.totalWaterIntake, 1.0))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(Color.cyan)
                        .rotationEffect(.degrees(-90))

                    let icon = viewModel.waterIntake == 0 ? "zzz" :
                               viewModel.waterIntake < viewModel.totalWaterIntake / 2 ? "tortoise" :
                               viewModel.waterIntake < viewModel.totalWaterIntake ? "hare" : "hands.clap"
                    
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
                .frame(width: 347, height: 347)
                .padding(.bottom, 60)

                Text("\(viewModel.waterIntake, specifier: "%.1f") L")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.leading, 140)
                    .padding(.bottom, 0)

                Stepper(value: $viewModel.waterIntake, in: 0...viewModel.totalWaterIntake, step: 0.1) {
                    EmptyView()
                }
                .frame(width: 120)
                .padding(.leading, 100)
                .padding(.bottom, 100)
            }
            .navigationBarHidden(true)

            // Overlay for the welcome screen if the user hasn't started tracking
          
        }
        .onChange(of: viewModel.waterIntake) { _ in
            viewModel.updateCompletionStatus()
        }
    }
}

struct WaterIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        WaterIntakeView(totalWaterIntake: .constant(2.7))
    }
}
