import SwiftUI
import Charts

struct StatisticsCellView: View {
    static let preferredHeight: CGFloat = 180

    var body: some View {
        Chart {
            ForEach(Ester.allCases) { ester in
                ForEach(ester.points.sorted) { point in
                    LineMark(
                        x: .value("Injection Day", point.x),
                        y: .value("Concentration", point.y)
                    )
                    .foregroundStyle(by: .value("Ester", ester.configuration.name))

                    PointMark(
                        x: .value("Injection Day", point.x),
                        y: .value("Concentration", point.y)
                    )
                    .foregroundStyle(by: .value("Ester", ester.configuration.name))
                }
            }
        }
        .frame(height: Self.preferredHeight)
    }
}
