import SwiftUI

struct SearchInactiveView<AppStateManagerType: AppStateManageable>: View {
    @Environment(NavigationManager.self) var navigationManager: NavigationManager
    @Binding var activeSheet: ShortcutFeature?
    var appStateManager: AppStateManagerType
    
    let navigationItems: [AppArea]
    let actionItems: [ShortcutFeature]
    
    var body: some View {
        // MARK: Navigation Section
        Section(.navigationTitle) {
            VStack(spacing: 12) {
                ForEach(navigationItems) { item in
                    SearchSuggestionCellView(appArea: item, pressed: {
                        navigationManager.path.append(item)
                    })
                    .buttonStyle(.plain)
                    .contentShape(.accessibility, .rect)
                }
            }
            .listRowInsets(.vertical, 0)
            .listRowSeparator(.hidden)
        }
        
        // MARK: Quick Action Section
        Section(.actionsTitle) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .horizontalSpacing) {
                    ForEach(actionItems) { item in
                        Button(action: {
                            activeSheet = item
                        }, label: {
                            SearchActionCellView(configuration: .init(label: item.label,
                                                                      image: item.image))
                        })
                        .foregroundStyle(.primary)
                        .containerRelativeFrame(.horizontal,
                                                count: .horizontalCount,
                                                spacing: .horizontalSpacing)
                    }
                }
            }
            .scrollDisabled(Int.horizontalCount <= actionItems.count)
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

private extension Int {
    static let horizontalCount: Self = 2
}
