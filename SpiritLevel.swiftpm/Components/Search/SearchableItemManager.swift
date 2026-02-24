import SwiftUI

enum SearchItem {
    case navigation(feature: AppArea)
    case overview(feature: OverviewFeature)
    case statics(feaature: StatisticsFeature)
    case settings(feature: SettingsFeature)
}

//extension AppArea {
//    @ViewBuilder
//    func getDestinationView() -> some View {
//        switch self {
//        case .overview: Overview()
//        case .settings: SettingsView()
//        case .statisitcs: StatisticsView()
//        }
//    }
//}
//
//extension OverviewFeature {
//    func getDestinationView(title: String) -> some View {
//        List {
//            getEmbededView()
//        }
//        .navigationTitle(title)
//    }
//    
//    @ViewBuilder
//    private func getEmbededView() -> some View {
//        switch self {
//        case .mood: MoodCellView()
//        case .currentLevel: CurrentHormoneLevelCellView()
//        case .nextInjection: NextInjectionCellView()
//        case .trend: TrendCellView(configurations: [
//            .init(name: "Hormone Level", trend: .up),
//            .init(name: "Consistency", trend: .down)
//        ])
//        case .achivements: AchievementsCellView()
//        }
//    }
//}
