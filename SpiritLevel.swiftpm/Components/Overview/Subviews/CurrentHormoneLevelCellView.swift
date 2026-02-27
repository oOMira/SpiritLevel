import SwiftUI
import Charts

struct CurrentHormoneLevelCellView: View {
    static let today = Date()

    var body: some View {
        Text("ToDo")
    }
}

// MARK: - InjectionPoint

struct InjectionPoint: Identifiable {
    let id = UUID()
    let day: Double
    let concentration: Double
}
// MARK: - Constants

private extension CGFloat {
    static let chartHeight: Self = 200
}
