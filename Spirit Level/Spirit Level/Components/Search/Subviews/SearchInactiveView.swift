import SwiftUI

struct SearchInactiveView<AppStateManagerType: AppStateManageable>: View {
    @Binding var activeSheet: ShortcutFeature?
    var appStateManager: AppStateManagerType
    
    let navigationItems: [AppArea]
    let actionItems: [ShortcutFeature]
    
    var body: some View {
        // MARK: Navigation Section
        Section(.navigationTitle) {
            ForEach(navigationItems) { item in
                NavigationLink(value: item) {
                    SearchSuggestionCellView(configuration: .init(
                        label: item.label,
                        image: item.image,
                        color: item.accentColor
                    ))
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .listRowInsets(.vertical, 8)
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
