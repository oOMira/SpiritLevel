import SwiftUI

struct SplitViewLayout<DependenciesType: AppDependenciesProtocol>: View {
    
    @Bindable var dependencies: DependenciesType
    
    @State private var activeSheet: ShortcutFeature? = nil
    
    var body: some View {
        let enumeratedAppAreas = Array(AppArea.allCases.enumerated())
        NavigationSplitView {
            List(selection: $dependencies.appStateManager.selectedTab.toOptional()) {
                Label("Search", systemImage: "magnifyingglass")
                    .tag(-1)
                ForEach(enumeratedAppAreas, id: \.offset) { index, area in
                    Label(area.label, systemImage: area.systemImageName)
                }
            }
            .safeAreaInset(edge: .bottom) {
                ShortcutFeatureView(allFeatures: ShortcutFeature.allCases,
                                    activeSheet: $activeSheet)
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection: LogInjectionView(injectionRepository: dependencies.injectionRepository)
                        .presentationDetents([.large])
                case .logLab: LogLabResultView(labResultsRepository: dependencies.labResultsRepository)
                        .presentationDetents([.large])
                }
            }
        } detail: {
            if dependencies.appStateManager.selectedTab == -1 {
                CompactSearchView(appStateManager: dependencies.appStateManager,
                                  searchHistoryManager: .init(appStateManager: dependencies.appStateManager),
                                  searchResultsManager: dependencies.searchResultsManager)
            } else {
                let selectedAppArea = enumeratedAppAreas[dependencies.appStateManager.selectedTab].element
                switch selectedAppArea {
                case .overview:
                    OverviewContentView(dependencies: dependencies)
                case .statistics:
                    StatisticsView(injectionRepository: dependencies.injectionRepository,
                                   labResultsRepository: dependencies.labResultsRepository,
                                   hormoneLevelManager: dependencies.hormoneLevelManager)
                case .settings:
                    SettingsView(appStartRepository: dependencies.appStartRepository,
                                 appStateRepository: dependencies.appStateManager,
                                 injectionRepository: dependencies.injectionRepository,
                                 labResultsRepository: dependencies.labResultsRepository,
                                 treatmentPlanRepository: dependencies.treatmentPlanRepository,
                                 hormoneLevelManager: dependencies.hormoneLevelManager)
                }
            }
        }
    }
}

// MARK: - ShortcutFeatureView

private struct ShortcutFeatureView: View {
    private let allFeatures: [ShortcutFeature]
    @Binding private var activeSheet: ShortcutFeature?
    
    init(allFeatures: [ShortcutFeature], activeSheet: Binding<ShortcutFeature?>) {
        self.allFeatures = allFeatures
        self._activeSheet = activeSheet
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(ShortcutFeature.allCases) { feature in
                let button = Button(action: {
                    activeSheet = feature
                }, label: {
                    Text(feature.label)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                })
                .buttonBorderShape(.roundedRectangle)
                .tint(feature.buttonColor)
                .padding(.horizontal, 16)
                
                switch feature {
                case .logLab:
                    button.buttonStyle(.bordered)
                case .logInjection:
                    button.buttonStyle(.borderedProminent)
                }
            }
        }
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Helper

private extension Binding where Value == Int {
    func toOptional() -> Binding<Value?> {
        Binding<Value?>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 ?? 0 }
        )
    }
}

private extension ShortcutFeature {
    var buttonColor: Color {
        switch self {
        case .logInjection: return .accentColor
        case .logLab: return .primary
        }
    }
}
