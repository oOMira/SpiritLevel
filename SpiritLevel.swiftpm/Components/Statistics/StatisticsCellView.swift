import SwiftUI
import Charts

struct StatisticsCellView: View {
    static let preferredHeight: CGFloat = 180
    static let today = Date()

    let batemanModel = OneComponentBateman(t_half: Ester.enanthate.configuration.tHalf,
                                           t_max: Ester.enanthate.configuration.tMax,
                                           c_max: Ester.enanthate.configuration.cMax)

    static let injections: [Injection] = [
        .init(ester: .enanthate, dosage: 4.0, date: Calendar.current.date(byAdding: .day, value: -30, to: today) ?? Date()),
        .init(ester: .enanthate, dosage: 4.0, date: Calendar.current.date(byAdding: .day, value: -15, to: today) ?? Date()),
        .init(ester: .enanthate, dosage: 4.0, date: today),
        .init(ester: .enanthate, dosage: 4.0, date: Calendar.current.date(byAdding: .day, value: 15, to: today) ?? Date()),
        .init(ester: .enanthate, dosage: 4.0, date: Calendar.current.date(byAdding: .day, value: 30, to: today) ?? Date()),
        .init(ester: .enanthate, dosage: 4.0, date: Calendar.current.date(byAdding: .day, value: 45, to: today) ?? Date()),
    ]
    
    let levelManager = HormoneLevelManager(injections: injections)
    
    @State private var scrollPosition: Double = -3

    var body: some View {
        let today = Self.today
        let interval = Int(ceil(levelManager.lastIterval))
        let visibleRange = interval + .visibleRangeOffset
        
        return Chart {
            LinePlot(x: "x", y: "y") { x in
                let date = today.addingTimeInterval(x * .secondsPerDay)
                return levelManager.levelForDate(date)
            }
            .foregroundStyle(by: .value("Ester", "Injection"))
            ForEach(Self.injections) { injection in
                let day = injection.date.timeIntervalSince(today) / .secondsPerDay
                PointMark(
                    x: .value("Injection Day", day),
                    y: .value("Concentration", levelManager.levelForDate(injection.date))
                )
                .foregroundStyle(by: .value("Ester", "Injection"))
            }
        }
        .frame(height: .chartHeight)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: visibleRange)
        .chartScrollPosition(x: $scrollPosition)
        .chartXScale(domain: -30 ... interval + 30)
        .chartYScale(domain: 100 ... 350)
    }
}

// MARK: - Constants

private extension Int {
    static let visibleRangeOffset: Self = 5
}

private extension Double {
    static let secondsPerDay: Self = 86_400
}

private extension CGFloat {
    static let chartHeight: Self = 200
}

// MARK: - Preview

#Preview("Light Mode") {
    List {
        StatisticsCellView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    List {
        StatisticsCellView()
    }
    .preferredColorScheme(.dark)
}
