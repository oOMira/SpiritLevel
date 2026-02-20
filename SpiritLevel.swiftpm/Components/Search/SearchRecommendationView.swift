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
            Section("Navigation") {
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
            
            Section("Actions") {
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
                Button {
                    withAnimation { appState.allFeaturesExpanded.toggle() }
                } label: {
                    HStack {
                        Text("All Features")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.semibold))
                            .rotationEffect(.degrees(appState.allFeaturesExpanded ? 0 : -90))
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

@MainActor
private extension LocalizedStringKey {
    static let discoverTitle: Self = "Discover"
    static let topPicksTitle: Self = "Top Picks"
    static let browseTitle: Self = "Browse All"
}
