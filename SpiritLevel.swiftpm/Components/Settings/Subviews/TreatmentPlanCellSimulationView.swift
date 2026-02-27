import SwiftUI
import Charts

struct TreatmentPlanCellSimulationView: View {
    @Binding var simulationStyle: Int

    var body: some View {
        Chart { }
            .frame(height: .chartHeight)
            .chartXScale(domain: 0 ... 45)
            .chartYScale(domain: 0 ... 500)
    }
}

// MARK: - Constants


private extension CGFloat {
    static let chartHeight: Self = 200
}
