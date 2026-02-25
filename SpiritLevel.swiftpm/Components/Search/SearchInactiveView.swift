import SwiftUI

struct SearchInactiveView: View {
    @Binding var activeSheet: ShortcutFeature?
    @State private var appStateManager = AppStateManager.shared
    
    @Namespace private var animationNamespace
    private let addItemTransitionID = "addItemTransition"
    
    let navigationItems: [AppArea]
    let actionItems: [ShortcutFeature]
    
    var body: some View {
        Group {
            // MARK: Navigation Section
            Section(.navigationTitle) {
                ForEach(navigationItems, id: \.id) { item in
                    NavigationLink(destination: {
                        switch item {
                        case .overview: Overview(appStateManager: appStateManager)
                        case .statisitcs: StatisticsView()
                        case .settings: SettingsView()
                        }
                    }, label: {
                        SearchSuggestionCellView(configuration:
                                .init(label: item.label,
                                      image: item.image,
                                      color: item.accentColor))
                    })
                    .listRowInsets(.vertical, 8)
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
                            Button(action: {
                                activeSheet = item
                            }, label: {
                                SearchActionCellView(configuration:
                                        .init(label: item.label,
                                              image: item.image))
                            })
                            .foregroundStyle(.primary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollTargetLayout()
                .listRowSeparator(.hidden)
                .listRowInsets(.vertical, 0)
            }
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
