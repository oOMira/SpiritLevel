import SwiftUI

struct SearchInactiveView: View {
    @Binding var activeSheet: ShortcutFeature?
    @ObservedObject private var appState = AppStateManager.shared
    
    @Namespace private var animationNamespace
    private let addItemTransitionID = "addItemTransition"
    
    let navigationItems: [AppArea]
    let actionItems: [ShortcutFeature]
    let allItems: [any SearchableItem]
    
    var body: some View {
        Group {
            // MARK: Navigation Section
            Section(.navigationTitle) {
                ForEach(navigationItems, id: \.id) { item in
                    NavigationLink(destination: {
                        switch item {
                        case .overview: Overview()
                        case .statisitcs: StatisticsView()
                        case .settings: SettingsView()
                        }
                    }, label: {
                        SearchSuggestionCellView(configuration:
                                .init(label: item.label,
                                      image: item.image,
                                      color: item.accentColor))
                    })
                    .listRowInsets(.bottom, 0)
                    .navigationLinkIndicatorVisibility(.hidden)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            
            // MARK: Quick Action Section
            Section(.actionsTitle) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: .horizontalSpacing) {
                        ForEach(actionItems, id: \.id) { item in
                            SearchActionCellView(configuration:
                                    .init(label: item.label,
                                          image: item.image))
                            .onTapGesture {
                                activeSheet = item
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollTargetLayout()
                .listRowSeparator(.hidden)
                .listRowInsets(.vertical, 0)
            }
            
            // MARK: All Features Section
//            Section(isExpanded: $appState.allFeaturesExpanded) {
//                ForEach(allItems, id: \.id) { item in
//                    NavigationLink(destination: {
//                        List {
//                            AnyView(item.view)
//                        }
//                        .navigationTitle(item.label)
//                    }, label: {
//                        SearchResultCellView(label: item.label, image: item.image)
//                    })
//                }
//            } header: {
//                ExpandableSectionHeader(title: .browseTitle, expanded: $appState.allFeaturesExpanded)
//            }
        }
    }
}


// MARK: - Constants

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Navigation"
    static let actionsTitle: Self = "Quick Actions"
    static let browseTitle: Self = "All Features"
}
private extension CGFloat {
    static let horizontalSpacing: Self = 16
    static let listRowInsetVertical: Self = 0
    static let listRowInsetBottom: Self = 0
}
