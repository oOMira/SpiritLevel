import SwiftUI
import Charts

struct TreatmentPlanCellSimulationView<HormoneLevelManager: HormoneLevelManageable>: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = 250
    let hormoneManager: HormoneLevelManager
    @Bindable var store: TreatmentPlanStore
    @EnvironmentObject var appData: AppData
    var simulationStyle: SimulationStyle
    @State private var scrollPosition: Date = .now.addingTimeInterval(TimeInterval.interval)
    
    var body: some View {
        let visibleItems = store.planConfigurations.filter(\.visible)
                                .map(\.plan)
        let startDate: Date
        switch simulationStyle {
        case .firstInjection:
            startDate = appData.appStartDate
        case .stable:
            startDate = Calendar.current.date(byAdding: .day, value: -.numberOfCalculatedDatesInThePast, to: appData.appStartDate) ?? appData.appStartDate
        }

        // TODO: clean up, move to outside of body to help with perfromance
        return Chart(visibleItems) { item in
            let numberOfDaysInTheFuture = ClosedRange.xDomain.upperBound
            let calculateTime = numberOfDaysInTheFuture + (simulationStyle == .stable ? .numberOfCalculatedDatesInThePast : 0)
            let numberOfInjections: Int = calculateTime / item.frequency
            let injections = (0...numberOfInjections).map {
                let date = Calendar.current.date(byAdding: .day, value: $0 * item.frequency, to: startDate) ?? appData.appStartDate
                return Injection(ester: item.ester, dosage: item.dosage, date: date)
            }
            let values = ClosedRange.xDomain.map {
                let date = Calendar.current.date(byAdding: .day, value: $0, to: appData.appStartDate) ?? appData.appStartDate
                let level = hormoneManager.levelForInjections(injections, at: date)
                return (x: date, y: level)
            }
            
            ForEach(values.enumerated(), id: \.offset) {
                LineMark(
                    x: .value("Date", $1.x),
                    y: .value("Concentration", $1.y)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(by: .value("Plan", item.name))
                .accessibilityLabel(item.name)
                .accessibilityValue("\($1.y.formatted(.number.precision(.fractionLength(0)))) picogram per milliliter on \($1.x, format: .dateTime.day().month().year())")
                
                if accessibilityDifferentiateWithoutColor, $0.isMultiple(of: 3) {
                    PointMark(x: .value("Date", $1.x), y: .value("Concentration", $1.y))
                        .symbol(by: .value("Plan", item.name))
                        .foregroundStyle(by: .value("Plan", item.name))
                        .accessibilityHidden(true)
                }
            }
        }
        .accessibilityLabel("Chart showing simulated hormone levels for different treatment plans")
        .chartScrollableAxes(.horizontal)
        .chartScrollPosition(x: $scrollPosition)
        .chartXVisibleDomain(length: TimeInterval.interval * (250 / chartHeight))
        .scrollBounceBehavior(.basedOnSize)
        .frame(height: chartHeight)
        .animation(.easeInOut, value: visibleItems)
        .animation(.easeOut, value: simulationStyle)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let chartHeight: Self = 200
}

private extension ClosedRange where Bound == Int {
    static let xDomain: Self = 0 ... 45
}

private extension Int {
    static let numberOfCalculatedDatesInThePast = 90
}

private extension TimeInterval {
    static let interval = Double(ClosedRange.xDomain.upperBound) * Numbers.daysInSeconds
}
