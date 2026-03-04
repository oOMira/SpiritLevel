import SwiftUI
import Charts

struct HormoneLevelChartCell<InjectionRepositoryType: InjectionManageable,
                             HormoneLevelManagerType: HormoneLevelManageable>: View {
    @EnvironmentObject var appData: AppData
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = 180
    
    let injectionRepository: InjectionRepositoryType
    let hormoneManager: HormoneLevelManagerType

    
    // TODO: clean up, move to outside of body to help with perfromance, fully test voice over
    var body: some View {
        let injections = injectionRepository.allItems.filter { $0.date.start <= appData.appStartDate.start }
        
        let values = ClosedRange.xDomain.map {
            let date = Calendar.current.date(byAdding: .day, value: $0, to: appData.appStartDate) ?? appData.appStartDate
            let level = hormoneManager.levelForInjections(injections, at: date)
            return (x: date, y: level)
        }
        
        if injections.isEmpty {
            VStack(alignment: .leading) {
                Text(.noInjectionsTitle)
                    .font(.headline)
                Text(.noInjectionsMessage)
            }
            .accessibilityElement(children: .combine)
        } else {
            Chart(values.enumerated(), id: \.offset) {
                LineMark(
                    x: .value("Date", $1.x),
                    y: .value("Concentration", $1.y)
                )
                .interpolationMethod(.catmullRom)
                .accessibilityLabel("Simulated hormone level")
                .accessibilityValue("\($1.y.formatted(.number.precision(.fractionLength(0)))) picogram  pr milliliter on \($1.x, format: .dateTime.day().month().year())")
            }
            .accessibilityLabel("Chart showing simulated hormone levels based on logged injections")
            .frame(height: chartHeight)
            .animation(.easeInOut, value: injections)
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let chartHeight: Self = 200
}

private extension ClosedRange where Bound == Int {
    static let xDomain: Self = -14 ... 1
}

private extension LocalizedStringResource {
    static let noInjectionsTitle: Self = "No Injections Logged"
    static let noInjectionsMessage: Self = "Log injections to see simulated hormone levels"
}
