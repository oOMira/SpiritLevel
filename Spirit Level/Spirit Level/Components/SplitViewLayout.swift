import SwiftUI

struct SplitViewLayout<AppStateManagerType: AppStateManageable,
                       AppStartRepositoryType: AppStartManageable,
                       SearchResultsManagerType: SearchResultsManageable,
                       InjectionRepositoryType: InjectionManageable,
                       LabResultsRepositoryType: LabResultsManageable,
                       TreatmentPlanRepositoryType: TreatmentPlanManageable,
                       HormoneLevelManagerType: HormoneLevelManageable>: View {

    @Bindable var appStateManager: AppStateManagerType
    let appStartRepository: AppStartRepositoryType
    let searchResultsManager: SearchResultsManagerType
    let injectionRepository: InjectionRepositoryType
    let labResultsRepository: LabResultsRepositoryType
    let treatmentPlanRepository: TreatmentPlanRepositoryType
    let hormoneLevelManager: HormoneLevelManagerType
    let searchHistoryManager: SearchHistoryManager<AppStateManagerType>

    @State private var activeSheet: ShortcutFeature? = nil
    
    var body: some View {
        let enumeratedAppAreas = Array(AppArea.allCases.enumerated())
        NavigationSplitView {
            List(selection: $appStateManager.selectedTab.toOptional()) {
                Label("Search", systemImage: "magnifyingglass")
                    .tag(-1)
                ForEach(enumeratedAppAreas, id: \.offset) { index, area in
                    Label(area.label, systemImage: area.systemImageName)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 8) {
                    ForEach(ShortcutFeature.allCases, id: \.id) { feature in
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
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .logInjection: LogInjectionView(injectionRepository: injectionRepository)
                    .presentationDetents([.large])
                case .logLab: LogLabResultView(labResultsRepository: labResultsRepository)
                    .presentationDetents([.large])
                }
            }
        } detail: {
            if appStateManager.selectedTab == -1 {
                CompactSearchView(appStateManager: appStateManager,
                                  searchHistoryManager: searchHistoryManager,
                                  searchResultsManager: searchResultsManager)
            } else {
                let selectedAppArea = enumeratedAppAreas[appStateManager.selectedTab].element
                switch selectedAppArea {
                case .overview:
                    CompactOverview(appStateManager: appStateManager,
                                    appStartRepository: appStartRepository,
                                    injectionRepository: injectionRepository,
                                    labResultsRepository: labResultsRepository,
                                    treatmentPlanRepository: treatmentPlanRepository,
                                    hormoneManager: hormoneLevelManager)
                case .statistics:
                    StatisticsView(injectionRepository: injectionRepository,
                                   labResultsRepository: labResultsRepository,
                                   hormoneLevelManager: hormoneLevelManager)
                case .settings:
                    SettingsView(appStartRepository: appStartRepository,
                                 appStateRepository: appStateManager,
                                 injectionRepository: injectionRepository,
                                 labResultsRepository: labResultsRepository,
                                 treatmentPlanRepository: treatmentPlanRepository,
                                 hormoneLevelManager: hormoneLevelManager)
                }
            }
        }
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
