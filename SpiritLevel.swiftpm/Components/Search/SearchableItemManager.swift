import SwiftUI

enum SearchItem {
    case navigation(feature: AppArea)
    case overview(feature: OverviewFeature)
    case statics(feaature: StatisticsFeature)
    case settings(feature: SettingsFeature)
}

extension SearchItem: SearchableItem {
    init?(rawValue: String) { nil }
    
    var label: String {
        switch self {
        case .navigation(let feature): feature.label
        case .overview(let feature): feature.label
        case .statics(let feature): feature.label
        case .settings(let feature): feature.label
        }
    }
    
    var systemImageName: String {
        switch self {
        case .navigation(let feature): feature.systemImageName
        case .overview(let feature): feature.systemImageName
        case .statics(let feature): feature.systemImageName
        case .settings(let feature): feature.systemImageName
        }
    }
    
    var rawValue: String {
        switch self {
        case .navigation(let feature): feature.rawValue
        case .overview(let feature): feature.rawValue
        case .statics(let feature): feature.rawValue
        case .settings(let feature): feature.rawValue
        }
    }
    
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
