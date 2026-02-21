import SwiftUI
import Charts

struct CurrentHormoneLevelCellView: View {
    let batemanModel = OneComponentBateman(t_half: Ester.enanthate.configuration.tHalf,
                                           t_max: Ester.enanthate.configuration.tMax,
                                           c_max: Ester.enanthate.configuration.cMax)
    var body: some View {
        let points = stride(from: 0, through: 50, by: 1).map { ($0, batemanModel.getConcentrationAtTime($0) ?? 0) }
        return Chart {
            ForEach(points.enumerated(), id: \.0) { _, point in
                LineMark(
                    x: .value("Injection Day", point.0),
                    y: .value("Concentration", point.1)
                )
            }
        }
        .frame(height: 200)
    }
}
