import SwiftUI

extension AppArea {
    @ViewBuilder
    func getDestinationView() -> some View {
        switch self {
        case .overview: Overview()
        case .settings: SettingsView()
        case .statisitcs: StatisticsView()
        }
    }
}

extension OverviewFeature {
    func getDestinationView(title: String) -> some View {
        List {
            getEmbededView()
        }
        .navigationTitle(title)
    }
    
    @ViewBuilder
    private func getEmbededView() -> some View {
        switch self {
        case .mood: MoodCellView()
        case .currentLevel: CurrentHormoneLevelCellView()
        case .nextInjection: NextInjectionCellView()
        case .trend: TrendCellView(configurations: [
            .init(name: "Hormone Level", trend: .up),
            .init(name: "Consistency", trend: .down)
        ])
        case .achivements: AchievementsCellView()
        }
    }
}

enum SearchItem {
    case navigation(feature: AppArea, destinationView: () -> any View)
    case overview(feature: OverviewFeature, destinationView: () -> any View)
}

extension SearchItem {
    private var searchableItem: any SearchableItem {
        switch self {
        case .navigation(feature: let feature as any SearchableItem,
                         destinationView: _),
                .overview(feature: let feature as any SearchableItem,
                          destinationView: _):
            return feature
        }
    }

    
    var label: String {
        searchableItem.label
    }
    
    var image: Image {
        searchableItem.image
    }
    
    var destinationView: () -> any View {
        switch self {
        case .navigation(feature: _, destinationView: let destinationView),
                .overview(feature: _, destinationView: let destinationView):
            return destinationView
        }
    }
}
