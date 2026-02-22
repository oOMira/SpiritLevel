import SwiftUI
import Charts

struct CurrentHormoneLevelCellView: View {
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

    var body: some View {
        let today = Self.today
        let interval = Int(ceil(levelManager.lastIterval))
        return Chart {
            LinePlot(x: "x", y: "y") { x in
                let date = today.addingTimeInterval(x * 86_400)
                return levelManager.levelForDate(date)
            }
            .foregroundStyle(by: .value("Ester", "Injection"))
            ForEach(Self.injections) { injection in
                let day = injection.date.timeIntervalSince(today) / 86_400
                PointMark(
                    x: .value("Injection Day", day),
                    y: .value("Concentration", levelManager.levelForDate(injection.date))
                )
                .foregroundStyle(by: .value("Ester", "Injection"))
            }
        }
        .frame(height: 200)
        .chartXScale(domain: -3 ... interval + 2)
        .chartYScale(domain: 100 ... 350)
    }
}
