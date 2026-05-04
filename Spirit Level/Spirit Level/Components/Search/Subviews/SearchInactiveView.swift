import SwiftUI

struct SearchInactiveView<AppStateMgr: AppStateManageable,
                          SearchManagerType: SearchResultsManageable>: View {
    @State var expanded: Bool = true

    @Binding var path: NavigationPath
    @Binding var activeSheet: ShortcutFeature?
    var appStateManager: AppStateMgr
    var searchManager: SearchManagerType

    let navigationItems: [AppArea]
    let actionItems: [ShortcutFeature]

    var body: some View {
        // MARK: Navigation Section
        Section(.navigationTitle) {
            VStack(spacing: 12) {
                ForEach(navigationItems) { item in
                    SearchSuggestionCellView(appArea: item, pressed: {
                        path.append(item)
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

        // MARK: All Features
        Section(isExpanded: $expanded, content: {
            ForEach(searchManager.items) { item in
                NavigationLink(value: item) {
                    SearchResultCellView(label: item.label, image: item.image)
                }
                .listRowInsets(.leading, 16)
            }
        }, header: {
            HStack {
                ExpandableSectionHeader(title: "All Features",
                                        expanded: $expanded)
            }
        })
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

// MARK: - Previews

#Preview("Light Mode") {
    @Previewable @State var activeSheet: ShortcutFeature?
    @Previewable @State var path = NavigationPath()
    let deps = Mocks.appDependencies
    let searchManager = SearchResultsManager(items: SearchResultsManager.getDefaultItems(dependencies: deps))
    List {
        SearchInactiveView(path: $path,
                           activeSheet: $activeSheet,
                           appStateManager: deps.appStateManager,
                           searchManager: searchManager,
                           navigationItems: AppArea.allCases,
                           actionItems: ShortcutFeature.allCases)
    }
    .listStyle(.plain)
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    @Previewable @State var activeSheet: ShortcutFeature?
    @Previewable @State var path = NavigationPath()
    let deps = Mocks.appDependencies
    let searchManager = SearchResultsManager(items: SearchResultsManager.getDefaultItems(dependencies: deps))
    List {
        SearchInactiveView(path: $path,
                           activeSheet: $activeSheet,
                           appStateManager: deps.appStateManager,
                           searchManager: searchManager,
                           navigationItems: AppArea.allCases,
                           actionItems: ShortcutFeature.allCases)
    }
    .listStyle(.plain)
    .preferredColorScheme(.dark)
}
