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
        let isFirstInjection = simulationStyle == 0
        return Chart {
            LinePlot(x: "x", y: "y") { x in
                let date = today.addingTimeInterval(x * 86_400)
                return isFirstInjection ? firstEElevelManager.levelForDate(date) : stableEElevelManager.levelForDate(date)
            }
            .foregroundStyle(by: .value("Ester", "EE"))
            
            LinePlot(x: "x", y: "y") { x in
                let date = today.addingTimeInterval(x * 86_400)
                return isFirstInjection ? firstEVlevelManager.levelForDate(date) : stableEVlevelManager.levelForDate(date)
            }
            .foregroundStyle(by: .value("Ester", "EV"))
        }
        .frame(height: 200)
        .chartXScale(domain: 0 ... 45)
        .chartYScale(domain: 0 ... 500)
    }
}

