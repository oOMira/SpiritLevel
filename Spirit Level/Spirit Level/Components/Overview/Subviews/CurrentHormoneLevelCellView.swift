import SwiftUI
import Charts

struct CurrentHormoneLevelCellView<InjectionRepositoryType: InjectionManageable,
                                   HormoneLevelManagerType: HormoneLevelManageable>: View {
    @EnvironmentObject var appData: AppData
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = 180
    
    let injectionRepository: InjectionRepositoryType
    let hormoneManager: HormoneLevelManagerType

    
    // TODO: clean up, move to outside of body to help with perfromance, fully test voice over
    var body: some View {
        let injections = injectionRepository.allItems.filter { $0.date.start <= appData.appStartDate.start }
        
        let values: [(x: Date, y: Double)] = ClosedRange.xDomain.compactMap {
            guard !injections.isEmpty else { return nil }
            let date = Calendar.current.date(byAdding: .day, value: $0, to: appData.appStartDate) ?? appData.appStartDate
            let level = hormoneManager.levelForInjections(injections, at: date)
            return (x: date, y: level)
        }
        
        
        var yDomain: ClosedRange<Double> {
            let dataMax = values.map(\.y).max() ?? 100
            return 0...(dataMax + 100)
        }
        
        Chart(values.enumerated(), id: \.offset) {
            LineMark(
                x: .value("Date", $1.x),
                y: .value("Concentration", $1.y)
            )
            .interpolationMethod(.catmullRom)
            .accessibilityLabel("Simulated hormone level")
            .accessibilityValue("\($1.y.formatted(.number.precision(.fractionLength(0)))) picogram  pr milliliter on \($1.x, format: .dateTime.day().month().year())")
        }
        .chartYScale(domain: yDomain)
        .opacity(injections.isEmpty ? 0.6 : 1.0)
        .accessibilityLabel("Chart showing simulated hormone levels based on logged injections")
        .frame(height: chartHeight)
        .overlay {
            if injections.isEmpty {
                VStack {
                    Text(.noInjectionsTitle)
                        .font(.headline)
                    Text(.noInjectionsMessage)
                        .multilineTextAlignment(.center)
                }
                .accessibilityElement(children: .combine)
            }
        }

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

private extension ClosedRange where Bound == Int {
    static let xDomain: Self = -14 ... 1
}

private extension LocalizedStringResource {
    static let noInjectionsTitle: Self = "No Injections Logged"
    static let noInjectionsMessage: Self = "Log injections to see simulated hormone levels"
}
