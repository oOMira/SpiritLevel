import SwiftUI
import Charts

struct TreatmentPlanCellSimulationView: View {
    @Binding var simulationStyle: Int
    let today = Date()
    let batemanModel = OneComponentBateman(t_half: Ester.enanthate.configuration.tHalf,
                                           t_max: Ester.enanthate.configuration.tMax,
                                           c_max: Ester.enanthate.configuration.cMax)
    
    let stableEElevelManager = HormoneLevelManager(injections: Ester.enanthate.stableInjections)
    let stableEVlevelManager = HormoneLevelManager(injections: Ester.valerate.stableInjections)
    let firstEElevelManager = HormoneLevelManager(injections: Ester.enanthate.firstInjections)
    let firstEVlevelManager = HormoneLevelManager(injections: Ester.valerate.firstInjections)

    var body: some View {
        let isFirstInjection = simulationStyle == .firstInjectionTag
        return Chart {
            LinePlot(x: "x", y: "y") { x in
                let date = today.addingTimeInterval(x * .secondsPerDay)
                return isFirstInjection ? firstEElevelManager.levelForDate(date) : stableEElevelManager.levelForDate(date)
            }
            .foregroundStyle(by: .value("Ester", "EE"))
            
            LinePlot(x: "x", y: "y") { x in
                let date = today.addingTimeInterval(x * .secondsPerDay)
                return isFirstInjection ? firstEVlevelManager.levelForDate(date) : stableEVlevelManager.levelForDate(date)
            }
            .foregroundStyle(by: .value("Ester", "EV"))
        }
        .frame(height: .chartHeight)
        .chartXScale(domain: 0 ... 45)
        .chartYScale(domain: 0 ... 500)
    }
}

// MARK: - Constants

private extension Int {
    static let firstInjectionTag: Self = 0
}

private extension Double {
    static let secondsPerDay: Self = 86_400
}

private extension CGFloat {
    static let chartHeight: Self = 200
    static let xScaleMin: Self = 0
    static let xScaleMax: Self = 45
    static let yScaleMin: Self = 0
    static let yScaleMax: Self = 500
}
