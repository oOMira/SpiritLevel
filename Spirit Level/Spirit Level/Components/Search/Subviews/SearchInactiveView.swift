import SwiftUI

struct SearchInactiveView<AppStateManagerType: AppStateManageable>: View {
    @Environment(NavigationManager.self) var navigationManager: NavigationManager
    @Binding var activeSheet: ShortcutFeature?
    let namespace: Namespace.ID
    var appStateManager: AppStateManagerType
    
    let navigationItems: [AppArea]
    let actionItems: [ShortcutFeature]
    
    var body: some View {
        // MARK: Navigation Section
        Section(.navigationTitle) {
            VStack(spacing: 12) {
                ForEach(navigationItems) { item in
                    SearchSuggestionCellView(appArea: item, namespace: namespace, pressed: {
                        navigationManager.path.append(item)
                    })
                    .buttonStyle(.plain)
                    .matchedTransitionSource(id: item, in: namespace)
                }
            }
            .listRowInsets(.vertical, 0)
            .listRowSeparator(.hidden)
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


// MARK: - Constants

private extension LocalizedStringResource {
    static let navigationTitle: Self = "Navigation"
    static let actionsTitle: Self = "Quick Actions"
    static let browseTitle: Self = "All Features"
}
private extension CGFloat {
    static let horizontalSpacing: Self = 16
    static let listRowInsetVertical: Self = 0
    static let listRowInsetBottom: Self = 0
}
