import SwiftUI

struct SearchInactiveView: View {
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
                        AnyView(item.view)
                    }, label: {
                        SearchSuggestionCellView(configuration: .init(label: item.label,
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
                    HStack(spacing: 16) {
                        ForEach(actionItems, id: \.id) { item in
                            SearchActionCellView(configuration: .init(label: item.label,
                                                                      image: item.image))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollTargetLayout()
                .listRowSeparator(.hidden)
                .listRowInsets(.vertical, 0)
            }
            
            // MARK: All Features Section
            Section(isExpanded: $appState.allFeaturesExpanded) {
                ForEach(allItems, id: \.id) { item in
                    NavigationLink(destination: {
                        List {
                            AnyView(item.view)
                        }
                        .navigationTitle(item.label)
                    }, label: {
                        SearchResultCellView(label: item.label, image: item.image)
                    })
                }
            } header: {
                ExpandableSectionHeader(title: .browseTitle, expanded: $appState.allFeaturesExpanded)
            }
        }
    }
}

@MainActor
private extension LocalizedStringKey {
    static let navigationTitle: Self = "Navigation"
    static let actionsTitle: Self = "Quick Actions"
    static let browseTitle: Self = "All Features"
}
