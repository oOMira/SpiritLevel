import SwiftUI
import Charts

typealias CurrentHormoneLevelCellDependencies = HasInjectionRepository & HasHormoneLevelManager

@Observable
final class CurrentHormoneLevelCellViewModel<Dependencies: CurrentHormoneLevelCellDependencies> {
    var dependencies: Dependencies
    var appStartDate = Date()

    var hasInjections: Bool {
        !dependencies.injectionRepository.allItems.isEmpty
    }

    var values: [(x: Date, y: Double)] {
        ClosedRange.xDomain.compactMap { day -> (x: Date, y: Double)? in
            let injections = dependencies.injectionRepository.allItems.filter {
                $0.date.start <= appStartDate
            }
            guard !injections.isEmpty else { return nil }
            let date = Calendar.current.date(byAdding: .day, value: day, to: appStartDate)
                ?? appStartDate
            let level = dependencies.hormoneLevelManager.levelForInjections(injections, at: date)
            return (x: date, y: level)
        }
    }

    var xDomain: ClosedRange<Date> {
        let minX = ClosedRange.xDomain.lowerBound.addDaysToDate(appStartDate)
        let maxX = ClosedRange.xDomain.upperBound.addDaysToDate(appStartDate)
        return (minX...maxX)
    }

    var yDomain: ClosedRange<Double> {
        let dataMax = values.map(\.y).max() ?? 100
        return 0...(dataMax + 100)
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

struct CurrentHormoneLevelCellView<Dependencies: CurrentHormoneLevelCellDependencies>: View {
    @Environment(AppData.self) var appData: AppData
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = 180

    private var viewModel: CurrentHormoneLevelCellViewModel<Dependencies>

    init(viewModel: CurrentHormoneLevelCellViewModel<Dependencies>) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if viewModel.hasInjections {
                Text("Estimated E2 Level in pg/mL")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
            }
            Chart(viewModel.values.enumerated(), id: \.offset) {
                LineMark(
                    x: .value("Date", $1.x),
                    y: .value("Concentration", $1.y)
                )
                .lineStyle(StrokeStyle(lineWidth: 2.5))
                .interpolationMethod(.catmullRom)
                .accessibilityLabel("Simulated hormone level")
                .accessibilityValue(
                    accessibilityValue(for: $1.y, at: $1.x)
                )
            }
            .onAppear { viewModel.appStartDate = appData.appStartDate }
            .onChange(of: appData.appStartDate, { _, newValue in
                viewModel.appStartDate = newValue
            })
            .chartXScale(domain: viewModel.xDomain)
            .chartYScale(domain: viewModel.yDomain)
            .opacity(viewModel.hasInjections ? 1.0 : 0.6)
            .accessibilityLabel(
                "Chart showing simulated hormone levels based on logged injections"
            )
            .frame(height: chartHeight)
            .overlay {
                if !viewModel.hasInjections { emptyOverlay }
            }
        }
        .accessibilityElement(children: .contain)
    }

    var emptyOverlay: some View {
        VStack {
            Text(.noInjectionsTitle)
                .font(.headline)
            Text(.noInjectionsMessage)
                .multilineTextAlignment(.center)
        }
        .accessibilityElement(children: .combine)
    }
}

private extension CurrentHormoneLevelCellView {
    func accessibilityValue(for level: Double, at date: Date) -> String {
        let formattedLevel = level.formatted(.number.precision(.fractionLength(0)))
        let formattedDate = date.formatted(.dateTime.day().month().year())
        return "\(formattedLevel) picograms per milliliter on \(formattedDate)"
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

private extension Int {
    func addDaysToDate(_ date: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: self, to: date) ?? date
    }
}

private extension ClosedRange where Bound == Int {
    static let xDomain: Self = -14 ... 1
}

private extension LocalizedStringResource {
    static let noInjectionsTitle: Self = "No Injections Logged"
    static let noInjectionsMessage: Self = "Log injections to see simulated hormone levels"
}

// MARK: - Previews

#Preview("Light Mode") {
    CurrentHormoneLevelCellView(viewModel: .init(dependencies: Mocks.appDependencies))
        .environment(AppData())
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CurrentHormoneLevelCellView(viewModel: .init(dependencies: Mocks.appDependencies))
        .environment(AppData())
        .preferredColorScheme(.dark)
}
